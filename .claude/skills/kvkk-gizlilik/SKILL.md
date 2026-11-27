---
name: kvkk-gizlilik
description: Türkiye'de kişisel veri işleyen bir mobil uygulama için KVKK aydınlatma metni, açık rıza, yurt dışına aktarım, veri envanteri, saklama süreleri ve hesap/veri silme gereksinimlerini hazırlar. Gizlilik politikası, KVKK metni, veri envanteri veya Firebase gibi yurt dışı servis kullanımı konuşulduğunda kullan.
---

# KVKK ve gizlilik hazırlığı

Bu skill hukuki tavsiye değildir. Ürettiğin her metnin başına şunu yaz:
"TASLAK: Yayından önce bir KVKK uzmanı/avukat tarafından gözden geçirilmelidir."

## Adım 1: Veri envanteri
Her veri kalemi için tablo doldur: veri, kategori (kimlik, iletişim, görsel/işitsel, konum, cihaz, kullanım), amaç, hukuki sebep (KVKK m.5/m.6), saklama süresi, aktarılan taraflar, aktarılan ülke.
Düğün uygulamasına özel dikkat:
- Fotoğraf/video: yüzler, çocuklar, üçüncü kişiler. Yükleyen kişi başkalarının verisini işliyor; kullanım koşullarında yükleyen kullanıcının sorumluluğunu ve kaldırma talebini düzenle.
- Fotoğraf EXIF verisi (konum, cihaz): sunucuya yüklemeden önce temizle.
- Yüz tanıma eklenirse biyometrik veri = özel nitelikli kişisel veri (m.6). Açık rıza ve ek önlem gerekir; MVP'de önerme.

## Adım 2: Hukuki sebepler
- Hesap ve hizmet: sözleşmenin ifası (m.5/2-c).
- Analitik/çökme raporu: meşru menfaat veya açık rıza (tartışmalı; uzmana sor, VARSAYIM olarak işaretle).
- Pazarlama bildirimi/e-posta: açık rıza + İYS (İleti Yönetim Sistemi) kaydı gerekebilir.
- Açık rıza hizmet şartına bağlanamaz, ayrı ve isteğe bağlı olmalıdır.

## Adım 3: Yurt dışına aktarım
Firebase/Google Cloud, Supabase, AWS gibi servisler veriyi yurt dışında işleyebilir. 2024 değişikliğiyle (m.9) yeterlilik kararı yoksa uygun güvenceler (ör. Kurul'un standart sözleşmesi, imzadan sonra 5 iş günü içinde Kurum'a bildirim) gündeme gelir. Bunu açık soru olarak kullanıcıya ve hukukçuya taşı; güncel kuralı kvkk.gov.tr'den doğrula.
Bölge seçimi (ör. europe-west) riski azaltır ama aktarımı ortadan kaldırmaz.

## Adım 4: Metinler
`docs/07-guvenlik/` altına:
1. `kvkk-aydinlatma.md`: veri sorumlusu, amaçlar, aktarılan taraflar, toplama yöntemi ve hukuki sebep, m.11 hakları, başvuru yolu.
2. `acik-riza.md`: sadece gerçekten rızaya dayanan işlemler için, her biri ayrı onay kutusu.
3. `gizlilik-politikasi.md`: Google Play için herkese açık bir URL'de yayınlanmalı (ör. Firebase Hosting). Türkçe ve İngilizce.
4. `kullanim-kosullari.md`: içerik kuralları, yaş sınırı, içerik kaldırma.

## Adım 5: Haklar ve silme
- Uygulama içinde "Hesabımı sil" akışı ve Play'in istediği uygulama dışı web silme bağlantısı.
- Silme kapsamı: hesap, yüklenen medya, yorumlar, yedekler (yedeklerden silme süresini yaz).
- Düğün sahibinin düğünü silmesi: tüm davetli içeriği ne olur? Karar olarak kullanıcıya sor.

## Adım 6: VERBİS
Küçük işletmeler için VERBİS kayıt muafiyeti olabilir (çalışan sayısı ve bilanço eşiklerine bağlı). Şirket yapısı belli olunca uzmana doğrulat; kendi başına "muafsın" deme.

## Kontrol listesi
- [ ] Veri envanteri tamam ve her kalemin hukuki sebebi var
- [ ] Aydınlatma metni kayıt ekranından erişilebilir
- [ ] Açık rızalar ayrı ve isteğe bağlı
- [ ] Yurt dışı aktarım kararı hukukçuyla verildi
- [ ] Gizlilik politikası herkese açık URL'de
- [ ] Uygulama içi ve web üzerinden hesap silme çalışıyor
- [ ] EXIF temizleniyor
- [ ] Play Veri Güvenliği formu envanterle birebir uyumlu
