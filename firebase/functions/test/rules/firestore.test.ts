import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { collection, deleteDoc, doc, getDoc, getDocs, orderBy, query, serverTimestamp, setDoc, Timestamp, updateDoc, where } from 'firebase/firestore';
import { readFileSync } from 'fs';
import { join } from 'path';

let env: RulesTestEnvironment;
const W = 'w1';
const H = 3600 * 1000;
const ts = (ms: number) => Timestamp.fromMillis(Date.now() + ms);

async function seed(opts: { katilimciOpen?: boolean; uploadOpen?: boolean; status?: string } = {}) {
  const k = opts.katilimciOpen ?? true; const u = opts.uploadOpen ?? true;
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, `weddings/${W}`), {
      title: 'Ayşe & Mehmet', status: opts.status ?? 'active', requireApproval: true,
      modules: {
        katilimci: { enabled: true, start: ts(k ? -H : H), end: ts(k ? H : 2 * H) },
        paylasim: { enabled: true, uploadStart: ts(u ? -H : -2 * H), uploadEnd: ts(u ? H : -H) },
      },
      createdAt: Timestamp.now(),
    });
    await setDoc(doc(db, `weddings/${W}/members/owner`), { role: 'owner', status: 'active', displayName: 'Ayşe', joinedAt: Timestamp.now() });
    await setDoc(doc(db, `weddings/${W}/members/guest`), { role: 'guest', status: 'active', displayName: 'Ali', joinedAt: Timestamp.now() });
    await setDoc(doc(db, `weddings/${W}/members/pending`), { role: 'guest', status: 'pending', displayName: 'Veli', joinedAt: Timestamp.now() });
    await setDoc(doc(db, `weddings/${W}/private/invite`), { guestCode: 'ABCDEFG', ownerCode: 'ABCDEFGHJK' });
    await setDoc(doc(db, `codes/ABCDEFG`), { weddingId: W, type: 'guest', active: true });
    await setDoc(doc(db, `weddings/${W}/posts/p1`), {
      authorUid: 'guest', authorName: 'Ali', mediaPath: `weddings/${W}/posts/p1/a.jpg`, mediaType: 'image',
      createdAt: Timestamp.now(), status: 'visible', likeCount: 0, commentCount: 0,
    });
    await setDoc(doc(db, `weddings/${W}/posts/hidden`), {
      authorUid: 'owner', authorName: 'Ayşe', mediaPath: `weddings/${W}/posts/hidden/a.jpg`, mediaType: 'image',
      createdAt: Timestamp.now(), status: 'hidden', likeCount: 0, commentCount: 0,
    });
  });
}

const as = (uid: string, claims: Record<string, unknown> = {}) => env.authenticatedContext(uid, claims).firestore();
const newPost = (uid: string, id: string, extra: object = {}) => ({
  authorUid: uid, authorName: 'Ali', mediaPath: `weddings/${W}/posts/${id}/foto.jpg`, mediaType: 'image',
  createdAt: serverTimestamp(), status: 'visible', likeCount: 0, commentCount: 0, ...extra,
});

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-murevet',
    firestore: { rules: readFileSync(join(__dirname, '../../../firestore.rules'), 'utf8') },
  });
});
afterAll(async () => env.cleanup());
beforeEach(async () => { await env.clearFirestore(); });

describe('kapalı düğün', () => {
  test('üye olmayan düğünü ve içeriği okuyamaz', async () => {
    await seed();
    const db = as('stranger');
    await assertFails(getDoc(doc(db, `weddings/${W}`)));
    await assertFails(getDoc(doc(db, `weddings/${W}/posts/p1`)));
    await assertFails(getDoc(doc(db, `weddings/${W}/members/guest`)));
  });
  test('giriş yapmamış kullanıcı hiçbir şey okuyamaz', async () => {
    await seed();
    await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), `weddings/${W}`)));
  });
  test('onay bekleyen davetli düğünü okuyamaz ama kendi üyelik durumunu görür', async () => {
    await seed();
    const db = as('pending');
    await assertFails(getDoc(doc(db, `weddings/${W}`)));
    await assertSucceeds(getDoc(doc(db, `weddings/${W}/members/pending`)));
  });
  test('aktif davetli düğünü okur', async () => {
    await seed();
    await assertSucceeds(getDoc(doc(as('guest'), `weddings/${W}`)));
  });
  test('kimse kodları okuyamaz, davetli davet kodunu göremez, sahip görür', async () => {
    await seed();
    await assertFails(getDoc(doc(as('owner'), 'codes/ABCDEFG')));
    await assertFails(getDoc(doc(as('guest'), `weddings/${W}/private/invite`)));
    await assertSucceeds(getDoc(doc(as('owner'), `weddings/${W}/private/invite`)));
  });
  test('istemci düğün oluşturamaz veya modülleri değiştiremez (yönetici dahil)', async () => {
    await seed();
    await assertFails(setDoc(doc(as('x'), 'weddings/new'), { title: 't', status: 'active' }));
    await assertFails(updateDoc(doc(as('owner'), `weddings/${W}`), { 'modules.paylasim.uploadEnd': ts(100 * H) }));
    await assertFails(updateDoc(doc(as('a', { admin: true }), `weddings/${W}`), { status: 'closed' }));
  });
  test('istemci kendine üyelik oluşturamaz veya rolünü yükseltemez', async () => {
    await seed();
    await assertFails(setDoc(doc(as('stranger'), `weddings/${W}/members/stranger`), { role: 'guest', status: 'active', displayName: 'X', joinedAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(as('guest'), `weddings/${W}/members/guest`), { role: 'owner' }));
    await assertFails(updateDoc(doc(as('pending'), `weddings/${W}/members/pending`), { status: 'active' }));
    await assertSucceeds(updateDoc(doc(as('guest'), `weddings/${W}/members/guest`), { displayName: 'Ali Can' }));
  });
  test('sahip davetliyi onaylar ve çıkarır, başka sahibe dokunamaz', async () => {
    await seed();
    await assertSucceeds(updateDoc(doc(as('owner'), `weddings/${W}/members/pending`), { status: 'active' }));
    await assertSucceeds(updateDoc(doc(as('owner'), `weddings/${W}/members/guest`), { status: 'removed' }));
    await assertFails(updateDoc(doc(as('owner'), `weddings/${W}/members/guest`), { role: 'owner' }));
  });
});

describe('Modül A: Katılımcı Organizasyonu', () => {
  const ev = { name: 'Kına', startAt: Timestamp.now(), venueName: 'Salon' };
  test('sahip modül açıkken etkinlik ekler, davetli ekleyemez', async () => {
    await seed();
    await assertSucceeds(setDoc(doc(as('owner'), `weddings/${W}/events/e1`), ev));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/events/e2`), ev));
  });
  test('modül süresi dışında sahip de yazamaz', async () => {
    await seed({ katilimciOpen: false });
    await assertFails(setDoc(doc(as('owner'), `weddings/${W}/events/e1`), ev));
  });
  test('harita bağlantısı https olmalı', async () => {
    await seed();
    await assertFails(setDoc(doc(as('owner'), `weddings/${W}/events/e1`), { ...ev, mapUrl: 'javascript:alert(1)' }));
  });
  test('davetli sadece kendi LCV belgesini yazar ve okur', async () => {
    await seed();
    const rsvp = { answer: 'yes', headcount: 2, updatedAt: serverTimestamp() };
    await assertSucceeds(setDoc(doc(as('guest'), `weddings/${W}/rsvps/guest`), rsvp));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/rsvps/owner`), rsvp));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/rsvps/guest`), { ...rsvp, headcount: 50 }));
    await assertSucceeds(getDoc(doc(as('owner'), `weddings/${W}/rsvps/guest`)));
    await assertFails(getDoc(doc(as('pending'), `weddings/${W}/rsvps/guest`)));
  });
});

describe('Modül B: Anı Paylaşımı', () => {
  test('aktif üye yükleme penceresinde gönderi oluşturur', async () => {
    await seed();
    await assertSucceeds(setDoc(doc(as('guest'), `weddings/${W}/posts/p2`), newPost('guest', 'p2')));
  });
  test('yükleme penceresi kapanınca gönderi oluşturulamaz ama okunabilir (düğün sonrası bulut erişimi)', async () => {
    await seed({ uploadOpen: false });
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p2`), newPost('guest', 'p2')));
    await assertSucceeds(getDoc(doc(as('guest'), `weddings/${W}/posts/p1`)));
  });
  test('başkası adına, sahte sayaçla veya başka düğünün yoluyla gönderi oluşturulamaz', async () => {
    await seed();
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p3`), newPost('owner', 'p3')));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p4`), newPost('guest', 'p4', { likeCount: 99 })));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p5`), newPost('guest', 'p5', { mediaPath: 'weddings/other/posts/p5/a.jpg' })));
    await assertFails(setDoc(doc(as('pending'), `weddings/${W}/posts/p6`), newPost('pending', 'p6')));
  });
  test('kapalı (closed) düğünde yazılamaz', async () => {
    await seed({ status: 'closed' });
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p2`), newPost('guest', 'p2')));
  });
  test('gizlenen gönderiyi davetli göremez, sahip görür', async () => {
    await seed();
    await assertFails(getDoc(doc(as('guest'), `weddings/${W}/posts/hidden`)));
    await assertSucceeds(getDoc(doc(as('owner'), `weddings/${W}/posts/hidden`)));
  });
  test('sahip gizler, davetli başkasının gönderisini değiştiremez veya silemez', async () => {
    await seed();
    await assertSucceeds(updateDoc(doc(as('owner'), `weddings/${W}/posts/p1`), { status: 'hidden' }));
    await assertFails(updateDoc(doc(as('guest'), `weddings/${W}/posts/hidden`), { status: 'visible' }));
    await assertFails(deleteDoc(doc(as('guest'), `weddings/${W}/posts/hidden`)));
    await assertSucceeds(deleteDoc(doc(as('guest'), `weddings/${W}/posts/p1`)));
  });
  test('beğeni sadece kendi adına, sayaç istemciden artırılamaz', async () => {
    await seed();
    await assertSucceeds(setDoc(doc(as('guest'), `weddings/${W}/posts/p1/likes/guest`), { uid: 'guest', createdAt: serverTimestamp() }));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p1/likes/owner`), { uid: 'owner', createdAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(as('guest'), `weddings/${W}/posts/p1`), { likeCount: 5 }));
  });
  test('yorum ve şikayet doğrulanır', async () => {
    await seed();
    await assertSucceeds(setDoc(doc(as('guest'), `weddings/${W}/posts/p1/comments/c1`), { authorUid: 'guest', authorName: 'Ali', text: 'Çok güzel', createdAt: serverTimestamp(), status: 'visible' }));
    await assertFails(setDoc(doc(as('guest'), `weddings/${W}/posts/p1/comments/c2`), { authorUid: 'guest', authorName: 'Ali', text: 'x'.repeat(501), createdAt: serverTimestamp(), status: 'visible' }));
    await assertSucceeds(setDoc(doc(as('guest'), `weddings/${W}/reports/r1`), { reporterUid: 'guest', targetType: 'post', targetId: 'p1', reason: 'inappropriate', createdAt: serverTimestamp() }));
    await assertFails(getDoc(doc(as('guest'), `weddings/${W}/reports/r1`)));
    await assertSucceeds(getDoc(doc(as('owner'), `weddings/${W}/reports/r1`)));
  });
});

describe('Modül B: uygulamanın sorguları', () => {
  test('davetli akışı sadece görünen gönderilerle sorgular; filtresiz sorgu reddedilir', async () => {
    await seed();
    const db = as('guest');
    const posts = collection(db, `weddings/${W}/posts`);
    await assertSucceeds(getDocs(query(posts, where('status', '==', 'visible'), orderBy('createdAt', 'desc'))));
    await assertFails(getDocs(query(posts, orderBy('createdAt', 'desc'))));
    await assertSucceeds(getDocs(query(collection(as('owner'), `weddings/${W}/posts`), orderBy('createdAt', 'desc'))));
  });
  test('davetli yorumları görünenlerle sorgular', async () => {
    await seed();
    const c = collection(as('guest'), `weddings/${W}/posts/p1/comments`);
    await assertSucceeds(getDocs(query(c, where('status', '==', 'visible'), orderBy('createdAt'))));
  });
  test('engelleme listesi sadece kullanıcıya ait', async () => {
    await seed();
    await assertSucceeds(setDoc(doc(as('guest'), 'users/guest/blocks/owner'), { createdAt: serverTimestamp() }));
    await assertFails(setDoc(doc(as('guest'), 'users/guest/blocks/guest'), { createdAt: serverTimestamp() }));
    await assertFails(getDocs(collection(as('owner'), 'users/guest/blocks')));
  });
});

describe('kullanıcı belgesi', () => {
  test('kullanıcı sadece kendi profilini okur', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'users/u1'), { displayName: 'A', email: 'a@b.co', createdAt: Timestamp.now() });
    });
    await assertSucceeds(getDoc(doc(as('u1'), 'users/u1')));
    await assertFails(getDoc(doc(as('u2'), 'users/u1')));
  });
  test('kullanıcı kendine üyelik kaydı yazamaz', async () => {
    await assertFails(setDoc(doc(as('u1'), `users/u1/memberships/${W}`), { weddingId: W, title: 'x', role: 'owner' }));
  });
});
