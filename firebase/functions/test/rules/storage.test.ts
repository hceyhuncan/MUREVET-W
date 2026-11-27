import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { doc, setDoc, Timestamp } from 'firebase/firestore';
import { deleteObject, getBytes, ref, uploadBytes } from 'firebase/storage';
import { readFileSync } from 'fs';
import { join } from 'path';

let env: RulesTestEnvironment;
const W = 'w1';
const H = 3600 * 1000;
const ts = (ms: number) => Timestamp.fromMillis(Date.now() + ms);
const bytes = (n: number) => new Uint8Array(n);
const meta = (uid: string, contentType = 'image/jpeg') => ({ contentType, customMetadata: { uploaderUid: uid } });

async function seed(uploadOpen = true) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, `weddings/${W}`), {
      title: 'A & M', status: 'active', requireApproval: false,
      modules: {
        katilimci: { enabled: false, start: ts(-H), end: ts(H) },
        paylasim: { enabled: true, uploadStart: ts(uploadOpen ? -H : -2 * H), uploadEnd: ts(uploadOpen ? H : -H) },
      },
      createdAt: Timestamp.now(),
    });
    await setDoc(doc(db, `weddings/${W}/members/guest`), { role: 'guest', status: 'active', displayName: 'Ali', joinedAt: Timestamp.now() });
    await setDoc(doc(db, `weddings/${W}/members/other`), { role: 'guest', status: 'active', displayName: 'Can', joinedAt: Timestamp.now() });
    await setDoc(doc(db, `weddings/${W}/members/pending`), { role: 'guest', status: 'pending', displayName: 'Veli', joinedAt: Timestamp.now() });
    await uploadBytes(ref(ctx.storage(), `weddings/${W}/posts/p1/media.jpg`), bytes(10), meta('guest'));
  });
}

const st = (uid: string) => env.authenticatedContext(uid).storage();

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-murevet',
    firestore: { rules: readFileSync(join(__dirname, '../../../firestore.rules'), 'utf8') },
    storage: { rules: readFileSync(join(__dirname, '../../../storage.rules'), 'utf8') },
  });
});
afterAll(async () => env.cleanup());
beforeEach(async () => {
  await env.clearFirestore();
  await env.clearStorage();
});

describe('Storage: anı medyası', () => {
  test('aktif üye pencere açıkken kendi adına görsel yükler', async () => {
    await seed();
    await assertSucceeds(uploadBytes(ref(st('guest'), `weddings/${W}/posts/p2/media.jpg`), bytes(100), meta('guest')));
  });
  test('başkası adına, görsel/video dışı türle veya 15 MB üstü görsel yüklenemez', async () => {
    await seed();
    const s = st('guest');
    await assertFails(uploadBytes(ref(s, `weddings/${W}/posts/p3/media.jpg`), bytes(10), meta('other')));
    await assertFails(uploadBytes(ref(s, `weddings/${W}/posts/p4/a.pdf`), bytes(10), meta('guest', 'application/pdf')));
    await assertFails(uploadBytes(ref(s, `weddings/${W}/posts/p5/media.jpg`), bytes(15 * 1024 * 1024 + 1), meta('guest')));
  });
  test('yükleme penceresi kapanınca yüklenemez ama okunur', async () => {
    await seed(false);
    await assertFails(uploadBytes(ref(st('guest'), `weddings/${W}/posts/p2/media.jpg`), bytes(10), meta('guest')));
    await assertSucceeds(getBytes(ref(st('guest'), `weddings/${W}/posts/p1/media.jpg`)));
  });
  test('üye olmayan ve onay bekleyen okuyamaz, yükleyemez', async () => {
    await seed();
    for (const uid of ['stranger', 'pending']) {
      await assertFails(getBytes(ref(st(uid), `weddings/${W}/posts/p1/media.jpg`)));
      await assertFails(uploadBytes(ref(st(uid), `weddings/${W}/posts/p9/media.jpg`), bytes(10), meta(uid)));
    }
  });
  test('sadece yükleyen kendi dosyasını siler; üzerine yazılamaz', async () => {
    await seed();
    await assertFails(deleteObject(ref(st('other'), `weddings/${W}/posts/p1/media.jpg`)));
    await assertFails(uploadBytes(ref(st('guest'), `weddings/${W}/posts/p1/media.jpg`), bytes(10), meta('guest')));
    await assertSucceeds(deleteObject(ref(st('guest'), `weddings/${W}/posts/p1/media.jpg`)));
  });
});
