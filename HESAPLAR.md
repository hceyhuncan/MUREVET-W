# Hesaplar, erişimler ve senin yapman gerekenler

Ajanlar bunları senin yerine açamaz: kimlik doğrulama, ödeme ve hukuki sorumluluk sende. Sırayla ve ihtiyaç anında aç; hepsini bugün açman gerekmiyor.

## Senin yapman gerekenler (sırasıyla)

| # | Ne | Ne zaman | Neden | Maliyet (DOĞRULA) |
|---|---|---|---|---|
| 1 | **GitHub reposu** oluştur (ör. `murevet`, özel) ve bu projeye bağla | Şimdi | Ofis dosyaları ve kod burada yaşayacak | Ücretsiz |
| 2 | Claude GitHub uygulamasını repoya kur ([Connect GitHub](https://claude.ai/connect-github)) | Repo açılınca | Ajanların dal açıp PR göndermesi için | Ücretsiz |
| 3 | **Bireysel mi kurumsal mı** Play hesabı açacağına karar ver | Kapı 1'den önce | Kurumsal hesap kapalı test şartından muaf ama şirket ve D-U-N-S ister | Şirket kuruluşu ayrı maliyet |
| 4 | **Google Play Console** geliştirici hesabı aç, kimliğini doğrula | Geliştirme başlarken (doğrulama günler sürebilir) | Yayın, test kanalları | Tek sefer ~25 USD |
| 5 | **Firebase** projeleri: `murevet-dev` ve `murevet-prod` (Google hesabınla) | Kapı 2 | Giriş, veritabanı, depolama, bildirim, çökme raporu | Spark ücretsiz; Storage ve Functions için Blaze (kullandıkça öde) gerekebilir, bütçe uyarısı kur |
| 6 | **Alan adı** (ör. murevet.app / .com.tr) | Kapı 2 | Gizlilik politikası, hesap silme sayfası, destek e-postası | Yıllık ~10-30 USD |
| 7 | **Destek e-postası** (ör. destek@alanadi) | Alan adıyla birlikte | Play iletişim adresi zorunlu | Değişken |
| 8 | **Kapalı test için testçi listesi** (Gmail adresleri) | Kapalı testten 2 hafta önce | Bireysel hesapta zorunlu (DOĞRULA: 12 kişi, 14 gün) | Ücretsiz |
| 9 | **Hukukçu** ile KVKK metinleri ve kullanım koşulları incelemesi | Kapı 3'ten önce | Hukuki metinler taslak olarak hazırlanacak | Değişken |
| 10 | **Marka/isim kontrolü** (TÜRKPATENT araması, Play'de isim çakışması) | Kapı 1 | İsim sonradan değişirse mağaza listesi ve ASO baştan yapılır | Arama ücretsiz, tescil ücretli |
| 11 | Uygulama imzalama **yükleme anahtarının** yedeği (parola yöneticisi) | İlk AAB'de | Kaybedilirse sıfırlama süreci uzun | Ücretsiz |

## Bilgisayarında olması gerekenler (geliştirmeyi yerelde yapacaksan)
- Flutter SDK (Dart dahil), Android Studio + Android SDK, en az bir emülatör veya Android telefon (USB hata ayıklama açık)
- Node.js (Firebase CLI ve Firebase MCP için), `firebase-tools`
- Git
Bulutta çalışırken bu kurulumlar oturum ortamında yapılır; yerel testler için telefon/emülatör yine de sende olmalı.

## İsteğe bağlı bağlantılar
- **Google Drive** bağlantın süresi dolmuş görünüyor; dokümanları Drive'da tutmak istersen yeniden bağlaman gerekir.
- **Figma**: tasarımı Figma'da görmek istersen bağlı, kullanılabilir.

## Ajanların hazırladığı, senin onaylayacağın şeyler
Play Console gönderimi, üretim Firebase değişiklikleri, dışarıya giden her mesaj/gönderi, ödeme gerektiren her servis.

## Gizli bilgiler kuralı
API anahtarları, keystore, parolalar asla repoya veya bu klasöre yazılmaz. Bulut ortamında "ortam gizli değişkenleri" kullanılır.
