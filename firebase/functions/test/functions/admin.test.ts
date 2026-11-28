import { initializeApp as adminInit, getApps } from 'firebase-admin/app';
import { getAuth as adminAuth } from 'firebase-admin/auth';
import { getFirestore as adminDb } from 'firebase-admin/firestore';
import { deleteApp, initializeApp } from 'firebase/app';
import { connectAuthEmulator, createUserWithEmailAndPassword, getAuth, signInAnonymously, signOut } from 'firebase/auth';
import { connectFunctionsEmulator, getFunctions, httpsCallable } from 'firebase/functions';

process.env.FIRESTORE_EMULATOR_HOST ??= '127.0.0.1:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST ??= '127.0.0.1:9099';
if (getApps().length === 0) adminInit({ projectId: 'demo-murevet' });

const app = initializeApp({ projectId: 'demo-murevet', apiKey: 'demo-key', authDomain: 'localhost' }, 'admin-test');
const auth = getAuth(app);
connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
const fns = getFunctions(app, 'europe-west1');
connectFunctionsEmulator(fns, '127.0.0.1', 5001);
const call = (name: string, data: unknown) => httpsCallable(fns, name)(data).then((r) => r.data as any);

const H = 3600 * 1000;
const iso = (ms: number) => new Date(Date.now() + ms).toISOString();
const modules = (katilimci = true, paylasim = true) => ({
  katilimci: { enabled: katilimci, start: iso(-H), end: iso(48 * H) },
  paylasim: { enabled: paylasim, uploadStart: iso(-H), uploadEnd: iso(24 * H) },
});

async function signInAsAdmin() {
  await signOut(auth);
  const { user } = await signInAnonymously(auth);
  await adminAuth().setCustomUserClaims(user.uid, { admin: true });
  await user.getIdToken(true);
  return user.uid;
}

afterAll(async () => { await deleteApp(app); });

test('yönetici paneli: paket modülleri ve süreleri günceller, ad davetlilerin listesine yansır', async () => {
  await signInAsAdmin();
  const w = await call('adminCreateWedding', { title: 'Eski Ad', modules: modules(true, false), contractRef: 'LS-1' });
  const snap0 = await adminDb().doc(`weddings/${w.weddingId}`).get();
  expect(snap0.data()?.modules.paylasim.enabled).toBe(false);

  await signOut(auth);
  await signInAnonymously(auth);
  await call('joinWithCode', { code: w.ownerCode, displayName: 'Sahip' });
  const ownerUid = auth.currentUser!.uid;

  await signInAsAdmin();
  await call('adminUpdateWedding', { weddingId: w.weddingId, title: 'Yeni Ad', modules: modules(true, true), requireApproval: false });
  const snap = await adminDb().doc(`weddings/${w.weddingId}`).get();
  expect(snap.data()).toMatchObject({ title: 'Yeni Ad', requireApproval: false, contractRef: 'LS-1' });
  expect(snap.data()?.modules.paylasim.enabled).toBe(true);
  const ms = await adminDb().doc(`users/${ownerUid}/memberships/${w.weddingId}`).get();
  expect(ms.data()?.title).toBe('Yeni Ad');
});

test('bitişi başlangıçtan önce olan süre ve yönetici olmayan güncelleme reddedilir', async () => {
  await signInAsAdmin();
  const w = await call('adminCreateWedding', { title: 'X', modules: modules() });
  const bad = { ...modules(), katilimci: { enabled: true, start: iso(H), end: iso(-H) } };
  await expect(call('adminUpdateWedding', { weddingId: w.weddingId, modules: bad })).rejects.toMatchObject({ code: 'functions/invalid-argument' });

  await signOut(auth);
  await signInAnonymously(auth);
  await expect(call('adminUpdateWedding', { weddingId: w.weddingId, status: 'closed' })).rejects.toMatchObject({ code: 'functions/permission-denied' });
  await expect(call('adminGrant', { email: 'x@test.com' })).rejects.toMatchObject({ code: 'functions/permission-denied' });
});

test('yönetici başka bir ekip üyesine yetki verir', async () => {
  await signOut(auth);
  const email = `ekip${Date.now()}@lotus.test`;
  const { user } = await createUserWithEmailAndPassword(auth, email, 'parola123');
  await signInAsAdmin();
  await call('adminGrant', { email });
  const u = await adminAuth().getUser(user.uid);
  expect(u.customClaims?.admin).toBe(true);
});
