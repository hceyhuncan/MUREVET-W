import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { CallableRequest, HttpsError, onCall } from 'firebase-functions/v2/https';
import { generateCode, GUEST_CODE_LENGTH, normalizeCode, OWNER_CODE_LENGTH } from './codes';
import { parseModules, reqString } from './validate';

initializeApp();
// VARSAYIM: Avrupa bölgesi (KVKK değerlendirmesi guvenlik-kvkk ajanında)
setGlobalOptions({ region: 'europe-west1', maxInstances: 10 });

const db = () => getFirestore();

const MAX_FAILED_ATTEMPTS = 10;
const ATTEMPT_WINDOW_MS = 60 * 60 * 1000;

function requireAuth(req: CallableRequest): string {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Giriş yapmalısınız');
  return req.auth.uid;
}

function requireAdmin(req: CallableRequest): string {
  const uid = requireAuth(req);
  if (req.auth?.token.admin !== true) throw new HttpsError('permission-denied', 'Yönetici yetkisi gerekli');
  return uid;
}

/**
 * Benzersiz kodlar üretir ve codes/{code} belgelerini yazar.
 * Firestore transaction kuralı gereği önce tüm okumalar, sonra yazmalar yapılır.
 */
async function createUniqueCodes(
  tx: FirebaseFirestore.Transaction, weddingId: string, types: Array<'owner' | 'guest'>,
): Promise<string[]> {
  for (let attempt = 0; attempt < 5; attempt++) {
    const codes = types.map((t) => generateCode(t === 'owner' ? OWNER_CODE_LENGTH : GUEST_CODE_LENGTH));
    if (new Set(codes).size !== codes.length) continue;
    const snaps = await Promise.all(codes.map((c) => tx.get(db().doc(`codes/${c}`))));
    if (snaps.some((s) => s.exists)) continue;
    codes.forEach((code, i) => tx.set(db().doc(`codes/${code}`), {
      weddingId, type: types[i], active: true, createdAt: FieldValue.serverTimestamp(),
    }));
    return codes;
  }
  throw new HttpsError('internal', 'Kod üretilemedi');
}

// ------------------------------------------------------------------
// Kodla katılım (ön modül → düğün)
// ------------------------------------------------------------------
export const joinWithCode = onCall(async (req) => {
  const uid = requireAuth(req);
  const code = normalizeCode(req.data?.code);
  const displayName = reqString(req.data?.displayName ?? req.auth?.token.name, 'displayName', 1, 60);

  const attemptsRef = db().doc(`joinAttempts/${uid}`);
  const now = Date.now();

  const recordFailure = async () => {
    await db().runTransaction(async (tx) => {
      const s = await tx.get(attemptsRef);
      const d = s.data();
      const fresh = !d || now - (d.windowStart as number) > ATTEMPT_WINDOW_MS;
      tx.set(attemptsRef, { windowStart: fresh ? now : d!.windowStart, failed: fresh ? 1 : (d!.failed as number) + 1 });
    });
  };

  const att = (await attemptsRef.get()).data();
  if (att && now - (att.windowStart as number) <= ATTEMPT_WINDOW_MS && (att.failed as number) >= MAX_FAILED_ATTEMPTS) {
    throw new HttpsError('resource-exhausted', 'Çok fazla hatalı deneme. Lütfen daha sonra tekrar deneyin.');
  }
  if (!code) {
    await recordFailure();
    throw new HttpsError('not-found', 'Kod geçersiz');
  }

  const codeSnap = await db().doc(`codes/${code}`).get();
  const c = codeSnap.data();
  if (!codeSnap.exists || !c || c.active !== true) {
    await recordFailure();
    throw new HttpsError('not-found', 'Kod geçersiz');
  }
  const weddingId = c.weddingId as string;
  const role = c.type as 'owner' | 'guest';

  return db().runTransaction(async (tx) => {
    const wRef = db().doc(`weddings/${weddingId}`);
    const mRef = wRef.collection('members').doc(uid);
    const [wSnap, mSnap] = await Promise.all([tx.get(wRef), tx.get(mRef)]);
    const w = wSnap.data();
    if (!w || w.status !== 'active') throw new HttpsError('failed-precondition', 'Bu düğün şu an erişime kapalı');

    const ownerCount = role === 'owner'
      ? (await tx.get(wRef.collection('members').where('role', '==', 'owner'))).size : 0;

    if (mSnap.exists) {
      const m = mSnap.data()!;
      if (m.status === 'removed') throw new HttpsError('permission-denied', 'Bu düğüne erişiminiz kaldırılmış');
      // Davetli koduyla gelen mevcut sahip rolünü kaybetmez; sahip koduyla gelen davetli sahip olur.
      if (role === 'owner' && m.role !== 'owner') {
        if (ownerCount >= 2) throw new HttpsError('failed-precondition', 'Bu düğünün sahip sayısı dolu');
        tx.update(mRef, { role: 'owner', status: 'active' });
        tx.set(db().doc(`users/${uid}/memberships/${weddingId}`), { role: 'owner' }, { merge: true });
      }
      return { weddingId, status: role === 'owner' ? 'active' : m.status, role: role === 'owner' ? 'owner' : m.role };
    }

    if (role === 'owner' && ownerCount >= 2) {
      throw new HttpsError('failed-precondition', 'Bu düğünün sahip sayısı dolu');
    }

    const status = role === 'owner' || w.requireApproval !== true ? 'active' : 'pending';
    tx.set(mRef, { role, status, displayName, joinedAt: FieldValue.serverTimestamp() });
    tx.set(db().doc(`users/${uid}/memberships/${weddingId}`), {
      weddingId, title: w.title, role, joinedAt: FieldValue.serverTimestamp(),
    });
    return { weddingId, status, role };
  });
});

// ------------------------------------------------------------------
// Yönetim paneli (Lotus ekibi, admin özel alanı gerekli)
// ------------------------------------------------------------------
export const adminCreateWedding = onCall(async (req) => {
  requireAdmin(req);
  const title = reqString(req.data?.title, 'title', 1, 80);
  const modules = parseModules(req.data?.modules);
  const requireApproval = req.data?.requireApproval !== false;
  const contractRef = req.data?.contractRef ? reqString(req.data.contractRef, 'contractRef', 1, 64) : null;

  const wRef = db().collection('weddings').doc();
  return db().runTransaction(async (tx) => {
    const [ownerCode, guestCode] = await createUniqueCodes(tx, wRef.id, ['owner', 'guest']);
    tx.set(wRef, {
      title, status: 'active', requireApproval, modules,
      ...(contractRef ? { contractRef } : {}),
      createdAt: FieldValue.serverTimestamp(),
    });
    tx.set(wRef.collection('private').doc('invite'), { guestCode, ownerCode, updatedAt: FieldValue.serverTimestamp() });
    return { weddingId: wRef.id, ownerCode, guestCode };
  });
});

export const adminUpdateWedding = onCall(async (req) => {
  requireAdmin(req);
  const weddingId = reqString(req.data?.weddingId, 'weddingId', 1, 64);
  const update: Record<string, unknown> = {};
  if (req.data?.modules !== undefined) update.modules = parseModules(req.data.modules);
  if (req.data?.status !== undefined) {
    if (!['active', 'closed'].includes(req.data.status)) throw new HttpsError('invalid-argument', 'status geçersiz');
    update.status = req.data.status;
  }
  if (req.data?.requireApproval !== undefined) update.requireApproval = req.data.requireApproval === true;
  if (req.data?.title !== undefined) update.title = reqString(req.data.title, 'title', 1, 80);
  if (Object.keys(update).length === 0) throw new HttpsError('invalid-argument', 'Değişiklik yok');
  const ref = db().doc(`weddings/${weddingId}`);
  if (!(await ref.get()).exists) throw new HttpsError('not-found', 'Düğün bulunamadı');
  await ref.update(update);
  return { ok: true };
});

/** Davetli kodunu yeniler. Yönetici veya düğün sahibi çağırabilir. */
export const rotateGuestCode = onCall(async (req) => {
  const uid = requireAuth(req);
  const weddingId = reqString(req.data?.weddingId, 'weddingId', 1, 64);
  const isAdmin = req.auth?.token.admin === true;
  return db().runTransaction(async (tx) => {
    const wRef = db().doc(`weddings/${weddingId}`);
    const inviteRef = wRef.collection('private').doc('invite');
    const [mSnap, invSnap] = await Promise.all([tx.get(wRef.collection('members').doc(uid)), tx.get(inviteRef)]);
    const m = mSnap.data();
    if (!isAdmin && !(m && m.role === 'owner' && m.status === 'active')) {
      throw new HttpsError('permission-denied', 'Sadece düğün sahibi kodu yenileyebilir');
    }
    const old = invSnap.data()?.guestCode as string | undefined;
    const [guestCode] = await createUniqueCodes(tx, weddingId, ['guest']);
    if (old) tx.update(db().doc(`codes/${old}`), { active: false });
    tx.set(inviteRef, { guestCode, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    return { guestCode };
  });
});

/** Lotus ekibine yönetici yetkisi verir. Sadece mevcut bir yönetici çağırabilir. İlk yönetici scripts/ ile atanır. */
export const adminGrant = onCall(async (req) => {
  requireAdmin(req);
  const email = reqString(req.data?.email, 'email', 3, 254);
  const user = await getAuth().getUserByEmail(email);
  await getAuth().setCustomUserClaims(user.uid, { ...(user.customClaims ?? {}), admin: true });
  return { uid: user.uid };
});

// ------------------------------------------------------------------
// Sayaçlar (istemci yazamaz)
// ------------------------------------------------------------------
export const onLikeWrite = onDocumentWritten('weddings/{w}/posts/{p}/likes/{uid}', async (event) => {
  const before = event.data?.before.exists; const after = event.data?.after.exists;
  const delta = !before && after ? 1 : before && !after ? -1 : 0;
  if (delta === 0) return;
  const ref = db().doc(`weddings/${event.params.w}/posts/${event.params.p}`);
  await ref.update({ likeCount: FieldValue.increment(delta) }).catch(() => undefined);
});

export const onCommentWrite = onDocumentWritten('weddings/{w}/posts/{p}/comments/{c}', async (event) => {
  const visible = (s?: FirebaseFirestore.DocumentSnapshot) => !!s?.exists && s.data()?.status === 'visible';
  const delta = (visible(event.data?.after) ? 1 : 0) - (visible(event.data?.before) ? 1 : 0);
  if (delta === 0) return;
  const ref = db().doc(`weddings/${event.params.w}/posts/${event.params.p}`);
  await ref.update({ commentCount: FieldValue.increment(delta) }).catch(() => undefined);
});

// ------------------------------------------------------------------
// Hesap silme (Google Play + KVKK)
// ------------------------------------------------------------------
export const deleteAccount = onCall(async (req) => {
  const uid = requireAuth(req);
  const firestore = db();
  const bucket = getStorage().bucket();
  const memberships = await firestore.collection(`users/${uid}/memberships`).get();

  for (const ms of memberships.docs) {
    const w = ms.id;
    const posts = await firestore.collection(`weddings/${w}/posts`).where('authorUid', '==', uid).get();
    for (const p of posts.docs) {
      await bucket.deleteFiles({ prefix: `weddings/${w}/posts/${p.id}/` }).catch(() => undefined);
      await firestore.recursiveDelete(p.ref);
    }
    await firestore.doc(`weddings/${w}/rsvps/${uid}`).delete();
    await firestore.doc(`weddings/${w}/members/${uid}`).delete();
  }
  // Başka gönderilere yazılan yorum ve beğeniler
  const comments = await firestore.collectionGroup('comments').where('authorUid', '==', uid).get();
  for (const c of comments.docs) await c.ref.delete();
  const likes = await firestore.collectionGroup('likes').where('uid', '==', uid).get();
  for (const l of likes.docs) await l.ref.delete();
  await firestore.recursiveDelete(firestore.doc(`users/${uid}`));
  await firestore.doc(`joinAttempts/${uid}`).delete();
  await getAuth().deleteUser(uid);
  return { ok: true, at: Timestamp.now().toMillis() };
});
