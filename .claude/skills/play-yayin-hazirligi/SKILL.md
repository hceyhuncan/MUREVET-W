---
name: play-yayin-hazirligi
description: Bir Android uygulamasını Google Play'e ilk kez yayınlamak için hesap, kapalı test, hedef API, imzalama, mağaza listesi görselleri, içerik derecelendirme, Veri Güvenliği ve aşamalı yayın adımlarını yürütür. Play Console, mağaza listesi, sürüm gönderimi veya reddedilme konuşulduğunda kullan.
---

# Google Play yayın hazırlığı

Google Play kuralları sık değişir. Aşağıdaki değerleri her yayından önce resmi kaynaktan doğrula (support.google.com/googleplay/android-developer ve developer.android.com) ve kontrol ettiğin tarihi yaz. Değerler 2026-11 itibarıyla bilinenlerdir ve "DOĞRULA" etiketlidir.

## 1. Hesap
- Geliştirici hesabı tek seferlik kayıt ücretiyle açılır (DOĞRULA: 25 USD). Kimlik ve (kurumsal hesapta) D-U-N-S doğrulaması gerekir.
- Bireysel hesap: kişisel ad mağazada görünür. Kurumsal hesap: şirket adı ve D-U-N-S numarası gerekir.
- 2023-11-13 sonrası açılan bireysel hesaplar üretime çıkmadan önce kapalı test yapmalıdır (DOĞRULA: en az 12 testçi, 14 gün kesintisiz). Kurumsal hesaplar bu kuraldan muaftır.
- Hesap sahibi bu adımları kendisi yapar. Ajan yalnızca rehberlik eder.

## 2. Teknik gereksinimler
- Format: Android App Bundle (.aab). Play App Signing açık olmalı; yükleme anahtarını güvenli sakla, kaybedersen sıfırlama süreci var.
- Hedef API: yeni uygulamalar güncel zorunlu `targetSdk` değerini karşılamalı (DOĞRULA: her yıl ağustos sonunda bir üst seviyeye çıkar).
- 64-bit destek, `versionCode` her yüklemede artmalı.
- İzinler: fotoğraf erişimi için tam medya izni yerine Fotoğraf Seçici (Photo Picker) kullan; Play "Fotoğraf ve video izinleri" politikası geniş erişimi kısıtlar.
- `play-policy-insights` skill'i ile yayın öncesi politika taraması çalıştır.

## 3. Mağaza listesi (bkz. sablonlar/magaza-listesi.md)
- Uygulama adı: en fazla 30 karakter
- Kısa açıklama: en fazla 80 karakter
- Uzun açıklama: en fazla 4000 karakter
- Simge: 512x512 PNG (32-bit, alfa)
- Öne çıkan görsel: 1024x500 PNG/JPG
- Ekran görüntüsü: telefon için en az 2 adet (öne çıkmak için 4+ önerilir), 16:9 veya 9:16, kenar 320-3840 px
- Kategori, iletişim e-postası, gizlilik politikası URL'si
(DOĞRULA: ölçüler)

## 4. Uygulama içeriği beyanları
- Gizlilik politikası, Reklamlar, Uygulama erişimi (giriş gerekiyorsa inceleme ekibine demo hesap), İçerik derecelendirme (IARC anketi), Hedef kitle ve içerik, Veri Güvenliği, Hesap silme URL'si, Haber/devlet/finans beyanları (uygulanmıyorsa hayır).
- Kullanıcı tarafından oluşturulan içerik var: `ugc-moderasyon` skill'indeki gereksinimleri karşıla.

## 5. Kanallar
Dahili test (100 kişiye kadar, hızlı) → Kapalı test (zorunlu testçi şartı burada sayılır) → Üretim başvurusu → Aşamalı yayın (ör. %5 → %20 → %50 → %100, her adımda çökme oranı ve ANR'ı kontrol et).
Android vitals eşikleri: kullanıcı kaynaklı çökme ve ANR oranlarını izle (DOĞRULA güncel kötü davranış eşikleri).

## 6. Reddedilme
Red e-postasındaki politika maddesini al, ilgili kodu/beyanı bul, düzeltme planı yaz, kullanıcı onayıyla yeniden gönder. Gerekirse itiraz metni taslağı hazırla.

## Kurallar
- Play Console'da gönderme, yayınlama, fiyat değiştirme gibi işlemleri asla kullanıcı onayı olmadan yapma.
- Her yayın için `docs/08-yayin/yayin-kontrol-listesi.md` dosyasını güncelle.
