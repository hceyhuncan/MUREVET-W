# Teknik Notlar (mobil + backend)
Sürüm: v0.1 · Tarih: 2026-11-27

## Yapı
```
app/                  Flutter uygulaması (Android; web hedefi yönetim paneli için)
  lib/domain/         Modeller ve kod biçimi
  lib/data/           Repository arayüzleri ve Firebase uygulamaları
  lib/ui/             Ekranlar (özellik bazında) ve tema
  lib/l10n/           Türkçe (varsayılan) ve İngilizce metinler
firebase/
  firestore.rules     Güvenlik kuralları (modül süreleri burada uygulanır)
  storage.rules
  functions/          Cloud Functions (kodla katılım, yönetim, sayaçlar, hesap silme) + testler
```
Uygulama kimliği: `com.murevet.app` (VARSAYIM, Play'e ilk yüklemeden önce Can ile kesinleşecek).

## Yerelde çalıştırma
Gerekli: Flutter 3.50.1, Node 22, Java 21, `firebase-tools` 14.
```bash
# Backend testleri (emülatörde)
cd firebase/functions && npm ci && npm run build
firebase emulators:exec --only auth,firestore,functions --project demo-murevet "npx jest --runInBand"

# Emülatörleri açık tut ve uygulamayı Android emülatöründe çalıştır
firebase emulators:start --project demo-murevet          # firebase/ klasöründe
cd app && flutter run --dart-define=USE_EMULATOR=true     # emülatör adresi 10.0.2.2
```
İlk yöneticiyi atamak (emülatör): Auth emülatöründe kullanıcıya `{"admin": true}` özel alanı verilir. Gerçek projede `scripts/` altında tek seferlik bir yönetici atama betiği olacak (PR D).

## Henüz yapılmayanlar
- Gerçek Firebase projesi (`murevet-dev`) ve `flutterfire configure` (Can'ın hesabı gerekli).
- Google ile girişin Android tarafı: SHA-1 parmak izi ve `google-services.json` gerçek projede eklenecek.
- QR okutma (kamera) ve `https://…/join?code=` bağlantı alanı (alan adı belli olunca).
- Storage kuralı testleri (PR C ile).
