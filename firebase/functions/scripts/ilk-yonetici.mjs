// İlk yöneticiyi atar. Sonraki yöneticiler panelden ("Yönetici ekle") eklenir.
//
// Kullanım (Can'ın bilgisayarında, proje sahibi hesabıyla):
//   gcloud auth application-default login
//   cd firebase/functions && npm ci
//   node scripts/ilk-yonetici.mjs <firebase-proje-id> <google-eposta>
//
// Kişi önce panele (veya uygulamaya) Google ile bir kez giriş yapmış olmalı.
// Anahtar dosyası gerekmez; repoya hiçbir gizli bilgi yazılmaz.
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

const [projectId, email] = process.argv.slice(2);
if (!projectId || !email) {
  console.error('Kullanım: node scripts/ilk-yonetici.mjs <firebase-proje-id> <google-eposta>');
  process.exit(1);
}

initializeApp({ credential: applicationDefault(), projectId });
const auth = getAuth();
const user = await auth.getUserByEmail(email);
await auth.setCustomUserClaims(user.uid, { ...(user.customClaims ?? {}), admin: true });
console.log(`${email} artık yönetici. Panelden çıkış yapıp tekrar girin.`);
