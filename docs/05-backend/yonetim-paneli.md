# Yönetim Paneli (Lotus ekibi)
Sürüm: v0.1 · Tarih: 2026-11-28 · Hazırlayan: mobil-gelistirici + backend-gelistirici

Sözleşme ofiste imzalandıktan sonra düğün bu panelden açılır. Uygulama içinde satış yoktur (KARAR).

## Ne yapar
| İş | Nasıl |
|---|---|
| Düğün açma | Ad, sözleşme no, paket, düğün günü → kodlar oluşur ve ekranda gösterilir |
| Paket | Tam paket (A+B), Katılımcı Organizasyonu (A), Anı Paylaşımı (B), Özel |
| Modül süreleri | Paket ve düğün gününe göre önerilir, tarih/saat seçiciyle değiştirilir |
| Onay | "Davetliler sahip onayıyla girsin" açık/kapalı |
| Kodlar | Sahip kodu (10 karakter, en fazla 2 sahip) ve davetli kodu (7 karakter) görünür, kopyalanır; davetli kodu yenilenebilir |
| Düğünü kapatma | Kapalı düğünde kimse yazamaz, üyeler görüntülemeye devam eder |
| Takip | Üye sayıları (aktif, onay bekleyen, sahip) ve şikayet listesi |
| Yönetici ekleme | E-posta ile (kişi önce bir kez Google ile giriş yapmış olmalı) |

TAHMİN önerilen süreler (sözleşmeye göre değiştirilir):
- A. Katılımcı Organizasyonu: düğün açıldığı günden düğünün 2 gün sonrasına kadar.
- B. Anı yükleme: düğün günü 00:00'dan 3 gün sonrasına kadar. Görüntüleme süresizdir.

## Güvenlik
- Panel sadece `admin: true` özel alanı olan Google hesaplarını içeri alır; asıl kontrol sunucuda (`requireAdmin`) ve güvenlik kurallarında.
- Tüm yazmalar Cloud Functions üzerinden: `adminCreateWedding`, `adminUpdateWedding`, `rotateGuestCode`, `adminGrant`.
- Ad değişince davetlilerin "Düğünlerim" listesindeki ad da güncellenir.
- Hosting: `noindex` ve `X-Frame-Options: DENY` başlıkları.

## Çalıştırma
- Yerel (emülatör): `cd firebase && firebase emulators:start --project demo-murevet`, sonra `cd app && flutter run -d chrome -t lib/main_admin.dart --dart-define=EMULATOR_HOST=127.0.0.1`
- Yayın (Firebase projesi açıldıktan sonra, Can'ın onayıyla): `flutter build web -t lib/main_admin.dart` → `firebase deploy --only hosting:admin`

## İlk yönetici
Proje açılınca bir kez, proje sahibi hesabıyla:
```
gcloud auth application-default login
cd firebase/functions && npm ci
node scripts/ilk-yonetici.mjs <firebase-proje-id> <google-eposta>
```
Anahtar dosyası gerekmez. Sonraki yöneticiler panelden eklenir.

## Açık noktalar
- DOĞRULA: Gerçek Firebase projesinde web uygulaması kaydı ve `firebase_options.dart` (`flutterfire configure`) gerekli; şimdilik demo ayarları kullanılıyor.
- VARSAYIM: Panel sadece Türkçe (iç araç).
- Sözleşme no sonradan değiştirilemiyor; gerekirse eklenir.
