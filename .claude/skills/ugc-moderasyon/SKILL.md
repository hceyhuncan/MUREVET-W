---
name: ugc-moderasyon
description: Kullanıcıların fotoğraf, video ve yorum paylaştığı bir uygulamada Google Play'in kullanıcı tarafından oluşturulan içerik (UGC) politikasına uyum için şikayet, engelleme, içerik kaldırma, kullanım koşulları ve moderasyon akışını tasarlar. Paylaşım, yorum, şikayet veya moderasyon özelliği yapılırken kullan.
---

# UGC ve moderasyon

Murevet'te davetliler fotoğraf, video ve yorum paylaşır. Google Play UGC politikası (DOĞRULA güncel metin) şunları bekler:

## Zorunlu özellikler (MVP'ye dahil)
1. Kullanım koşulları/içerik kuralları, kullanıcı içerik paylaşmadan önce kabul eder.
2. Her gönderi ve yorumda "Şikayet et" (sebep seçimi: uygunsuz, taciz, çıplaklık, telif, diğer).
3. Kullanıcıyı engelleme.
4. Düğün sahibi/yönetici için içerik gizleme ve kaldırma, kullanıcıyı düğünden çıkarma.
5. Şikayetlerin incelendiği bir yönetim kuyruğu (basit bir panel veya Firestore koleksiyonu + bildirim yeterli).
6. Yasa dışı içerik (özellikle çocuk istismarı) için sıfır tolerans ve kaldırma/bildirme süreci.

## Önerilen
- Otomatik ön tarama (ör. Cloud Vision SafeSearch) yalnızca maliyet ve KVKK değerlendirmesi sonrası.
- Özel düğün varsayılanı: içerik sadece düğün üyelerine görünür. Bu, riski ve moderasyon yükünü büyük ölçüde azaltır.
- Şikayet sonrası hedef yanıt süresi (ör. 24 saat) ve kayıt tutma.

## Veri modeli eklemeleri
`reports` (raporlayan, hedef içerik, sebep, durum, tarih), `blocks` (engelleyen, engellenen), gönderide `status: visible | hidden | removed`.

## Test
QA ajanı için senaryolar: şikayet gönderme, engellenen kullanıcının içeriğinin gizlenmesi, yöneticinin kaldırması, kaldırılan içeriğin tüm cihazlarda kaybolması.
