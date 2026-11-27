# Ürün Tanımı: Murevet
Sürüm: v0.1 · Tarih: 2026-11-27 · Durum: Taslak (Kapı 1 onayı bekliyor)

> Bu taslak, Can'ın "düğünler için sosyal medya uygulaması" fikrinden yola çıkıyor. Tüm `VARSAYIM:` etiketli maddeler Can'ın onayına açıktır. Pazar araştırması henüz yapılmadı; rakip ve rakamlar `docs/02-pazar/` aşamasında doğrulanacak.

## 1. Değer önerisi
**Düğün çiftleri ve davetliler için**, düğünde çekilen yüzlerce fotoğrafın ve anının WhatsApp gruplarına, farklı telefonlara ve sosyal medyaya dağılıp kaybolması problemini, **bir QR kod ile saniyeler içinde katılınan, sadece o düğünün davetlilerine özel bir paylaşım alanı** sunarak çözüyoruz. Genel sosyal medyadan farkı: özel, uygulamaya kayıt zahmeti çok az, tüm anılar tek albümde ve tam çözünürlükte.

VARSAYIM: Ürünün çekirdeği "düğün başına özel ortak albüm + akış". Herkese açık bir düğün sosyal ağı (keşfet, takip, influencer) MVP'de yok.

## 2. Personalar
| Persona | Hedefi | Acısı | Kullanım sıklığı |
|---|---|---|---|
| **Çift (gelin/damat)** | Düğünün tüm anılarını tek yerde, kaliteli toplamak | Fotoğraflar 10 farklı WhatsApp grubunda, sıkıştırılmış; kimden ne isteyeceğini bilmiyor | Düğün öncesi kurulum, düğün günü ve sonraki 2-4 hafta yoğun |
| **Davetli** | Çektiği fotoğrafları kolayca paylaşmak, diğerlerinin çektiklerini görmek | Yeni uygulama indirmek, hesap açmak istemez; tek seferlik kullanım | Düğün günü ve sonrası birkaç gün |
| **Düğün organizatörü / salon** (MVP sonrası) | Müşterilerine ek hizmet sunmak, marka görünürlüğü | Kendi uygulaması yok | Her düğünde tekrar eden |

## 3. Kullanım senaryoları
1. Çift olarak düğünümü oluşturup bir QR kod/davet bağlantısı almak istiyorum, böylece davetiyeye ve masalara koyabileyim.
2. Davetli olarak QR'ı okutup 2-3 adımda düğüne katılmak istiyorum, böylece hesap açma zahmetine girmeden fotoğraf yükleyebileyim.
3. Davetli olarak birden fazla fotoğraf ve kısa video yüklemek istiyorum, internet zayıf olsa bile yükleme sonradan tamamlansın.
4. Davetli olarak düğünün akışında diğerlerinin paylaşımlarını görmek, beğenmek ve yorum yapmak istiyorum.
5. Çift olarak tüm fotoğrafları tam çözünürlükte toplu indirmek istiyorum.
6. Çift olarak uygunsuz bir içeriği gizlemek veya bir kişiyi düğünden çıkarmak istiyorum.
7. Her kullanıcı olarak bir içeriği şikayet etmek, hesabımı ve içeriğimi silmek istiyorum (Play zorunluluğu).

## 4. MVP kapsamı (MoSCoW)
| Özellik | Öncelik | Senaryo | Not |
|---|---|---|---|
| Düğün oluşturma (isim, tarih, kapak fotoğrafı) | Must | 1 | |
| QR kod + davet bağlantısı ile katılma | Must | 2 | Bağlantı uygulama yoksa Play'e yönlendirir |
| Hafif giriş: Google ile giriş veya telefon numarası | Must | 2 | VARSAYIM: tamamen misafir (hesapsız) katılım yok, Play hesap silme ve moderasyon için kimlik gerekli |
| Fotoğraf yükleme (çoklu), çevrimdışı kuyruk | Must | 3 | EXIF/konum temizlenir |
| Kısa video yükleme (≤ 60 sn) | Should | 3 | Depolama maliyetini artırır |
| Düğün akışı (feed), beğeni, yorum | Must | 4 | |
| Ortak albüm görünümü (ızgara) | Must | 4 | |
| Toplu indirme (çift için) | Should | 5 | |
| Moderasyon: şikayet, engelleme, gizleme, çıkarma | Must | 6, 7 | Play UGC politikası |
| Hesap ve içerik silme (uygulama içi + web) | Must | 7 | Play zorunluluğu |
| Bildirim (yeni fotoğraf, yorum) | Should | 4 | |
| Türkçe + İngilizce arayüz | Must | | |
| Ücretli paket (premium) | Could | | Gelir modeline bağlı |
| Düğün öncesi geri sayım, program, davetli listesi/LCV | Could | | Kapsamı büyütür |
| Canlı slayt gösterisi (salondaki ekrana yansıtma) | Could | | Güçlü "vay" özelliği, MVP sonrası |
| Yüz tanıma ile "benim fotoğraflarım" | Won't (MVP) | | Biyometrik veri, KVKK özel nitelikli |
| Herkese açık keşfet/takip | Won't (MVP) | | Odak kaybı, moderasyon yükü |
| iOS | Won't (MVP) | | Flutter ile sonra kolay |

## 5. Kapsam dışı (MVP)
Düğün planlama araçları (bütçe, tedarikçi), mesajlaşma/DM, herkese açık profiller, reklam, web uygulaması (sadece silme ve gizlilik sayfaları hariç).

## 6. KPI'lar
| Ölçüt | Tanım | Hedef (ilk 90 gün) — TAHMİN |
|---|---|---|
| Oluşturulan düğün | Gerçek tarihli ve ≥ 10 katılımcılı düğün sayısı | 50 |
| Davetli aktivasyonu | QR'ı okutan davetlilerden en az 1 fotoğraf yükleyenlerin oranı | %35 |
| Düğün başına fotoğraf | Ortalama yüklenen fotoğraf | 150 |
| Katılım süresi | QR okutmadan ilk yüklemeye kadar geçen süre (medyan) | < 90 sn |
| Çökme olmayan kullanıcı oranı | Crashlytics | > %99,5 |
| Play puanı | | ≥ 4,4 |

## 7. Gelir modeli (seçenekler)
| Seçenek | Nasıl | Artı | Eksi |
|---|---|---|---|
| A. Freemium, düğün başına tek seferlik ücret | Ücretsiz: X fotoğraf / 30 gün saklama. Premium (TAHMİN: 299-799 TL): sınırsız, video, 1 yıl saklama, toplu indirme | Düğün zaten tek seferlik harcama; çiftin ödeme isteği yüksek | Play faturalandırması zorunlu (komisyon) |
| B. Tamamen ücretsiz (büyüme önce) | Gelir yok, depolama maliyeti bizde | En hızlı yayılma | Maliyet kontrolsüz büyür |
| C. Organizatör/salon aboneliği (B2B) | Salonlar her düğüne Murevet'i dahil eder | Tekrarlayan gelir, dağıtım kanalı | Satış eforu, MVP'de zor |

**Öneri:** A ile başla, ilk yayında ücretli katman kapalı olsun (sadece sınırlar ölçülsün), 2. sürümde aç. C'yi lansman sonrası pilot olarak dene.

## 8. Varsayımlar
- VARSAYIM: Öncelikli pazar Türkiye; arayüz Türkçe + İngilizce.
- VARSAYIM: Düğün içeriği varsayılan olarak sadece katılımcılara görünür.
- VARSAYIM: MVP sadece Android; 8-12 haftada yayınlanabilir büyüklükte.
- VARSAYIM: Teknoloji Flutter + Firebase (Kapı 2'de kesinleşir).
- VARSAYIM: "Murevet" adı mağaza adı olarak kullanılacak (marka/Play çakışma kontrolü gerekli).

## 9. Açık sorular (karar: Can)
- [ ] **Çekirdek:** Ürün "düğün başına özel ortak albüm + akış" mı, yoksa aklında daha geniş bir düğün sosyal ağı (çiftlerin birbirini takip ettiği, ilham aldığı) mı var?
- [ ] **Gelir modeli:** A (freemium, düğün başına ücret), B (ücretsiz) veya C (organizatör aboneliği)?
- [ ] **Giriş:** Davetliler Google/telefon ile mi girsin, yoksa ad yazarak misafir katılım mı olsun? (Misafir katılım daha kolay ama moderasyon ve Play silme gereksinimlerini zorlaştırır.)
- [ ] **İsim:** "Murevet" mağaza adı olarak kesin mi?
- [ ] Bu taslakta görmediğin, mutlaka olmasını istediğin bir özellik var mı?
