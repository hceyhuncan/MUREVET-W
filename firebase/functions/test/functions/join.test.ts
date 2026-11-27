import { initializeApp as adminInit } from 'firebase-admin/app';
import { getAuth as adminAuth } from 'firebase-admin/auth';
import { getFirestore as adminDb } from 'firebase-admin/firestore';
import { deleteApp, initializeApp } from 'firebase/app';
import { connectAuthEmulator, getAuth, signInAnonymously, signOut } from 'firebase/auth';
import { connectFunctionsEmulator, getFunctions, httpsCallable } from 'firebase/functions';

process.env.FIRESTORE_EMULATOR_HOST ??= '127.0.0.1:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST ??= '127.0.0.1:9099';
adminInit({ projectId: 'demo-murevet' });

const app = initializeApp({ projectId: 'demo-murevet', apiKey: 'demo-key', authDomain: 'localhost' });
const auth = getAuth(app);
connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
const fns = getFunctions(app, 'europe-west1');
connectFunctionsEmulator(fns, '127.0.0.1', 5001);
const call = (name: string, data: unknown) => httpsCallable(fns, name)(data).then((r) => r.data as any);

const H = 3600 * 1000;
const modules = () => ({
  katilimci: { enabled: true, start: new Date(Date.now() - H).toISOString(), end: new Date(Date.now() + 48 * H).toISOString() },
  paylasim: { enabled: true, uploadStart: new Date(Date.now() - H).toISOString(), uploadEnd: new Date(Date.now() + 24 * H).toISOString() },
});

async function signInAsAdmin() {
  await signOut(auth);
  const { user } = await signInAnonymously(auth);
  await adminAuth().setCustomUserClaims(user.uid, { admin: true });
  await user.getIdToken(true);
  return user.uid;
}
async function signInAsUser() {
  await signOut(auth);
  return (await signInAnonymously(auth)).user.uid;
}

afterAll(async () => { await deleteApp(app); });

test('yönetici olmayan düğün açamaz', async () => {
  await signInAsUser();
  await expect(call('adminCreateWedding', { title: 'X', modules: modules() })).rejects.toMatchObject({ code: 'functions/permission-denied' });
});

test('yönetici düğün açar; sahip ve davetli kodla katılır; onay akışı çalışır', async () => {
  await signInAsAdmin();
  const created = await call('adminCreateWedding', { title: 'Ayşe & Mehmet', modules: modules(), requireApproval: true, contractRef: 'LS-2026-001' });
  expect(created.ownerCode).toHaveLength(10);
  expect(created.guestCode).toHaveLength(7);

  const ownerUid = await signInAsUser();
  const o = await call('joinWithCode', { code: created.ownerCode, displayName: 'Ayşe' });
  expect(o).toMatchObject({ weddingId: created.weddingId, role: 'owner', status: 'active' });

  const guestUid = await signInAsUser();
  // Küçük harf ve boşlukla yazılan kod da kabul edilir
  const pretty = created.guestCode.toLowerCase().replace(/(...)/, '$1 ');
  const g = await call('joinWithCode', { code: pretty, displayName: 'Ali' });
  expect(g).toMatchObject({ role: 'guest', status: 'pending' });

  const m = await adminDb().doc(`weddings/${created.weddingId}/members/${guestUid}`).get();
  expect(m.data()).toMatchObject({ role: 'guest', status: 'pending', displayName: 'Ali' });
  const ms = await adminDb().doc(`users/${ownerUid}/memberships/${created.weddingId}`).get();
  expect(ms.data()).toMatchObject({ role: 'owner', title: 'Ayşe & Mehmet' });
});

test('yenilenen kodun eskisi çalışmaz; kaba kuvvet denemesi sınırlanır', async () => {
  await signInAsAdmin();
  const created = await call('adminCreateWedding', { title: 'B', modules: modules(), requireApproval: false });
  await signInAsUser();
  await call('joinWithCode', { code: created.ownerCode, displayName: 'Sahip' });
  const { guestCode } = await call('rotateGuestCode', { weddingId: created.weddingId });
  expect(guestCode).not.toBe(created.guestCode);

  await signInAsUser();
  await expect(call('joinWithCode', { code: created.guestCode, displayName: 'Ali' })).rejects.toMatchObject({ code: 'functions/not-found' });
  await expect(call('joinWithCode', { code: guestCode, displayName: 'Ali' })).resolves.toMatchObject({ status: 'active' });

  await signInAsUser();
  for (let i = 0; i < 10; i++) {
    await expect(call('joinWithCode', { code: 'ZZZZZZZ', displayName: 'X' })).rejects.toMatchObject({ code: 'functions/not-found' });
  }
  await expect(call('joinWithCode', { code: guestCode, displayName: 'X' })).rejects.toMatchObject({ code: 'functions/resource-exhausted' });
});

test('davetli kodu yenileyemez; kapalı düğüne katılınamaz', async () => {
  await signInAsAdmin();
  const created = await call('adminCreateWedding', { title: 'C', modules: modules(), requireApproval: false });
  await call('adminUpdateWedding', { weddingId: created.weddingId, status: 'closed' });
  await signInAsUser();
  await expect(call('joinWithCode', { code: created.guestCode, displayName: 'Ali' })).rejects.toMatchObject({ code: 'functions/failed-precondition' });
  await expect(call('rotateGuestCode', { weddingId: created.weddingId })).rejects.toMatchObject({ code: 'functions/permission-denied' });
});
