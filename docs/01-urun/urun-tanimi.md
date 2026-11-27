# Ürün Tanımı: Murevet
Sürüm: v0.1 · Tarih: 2026-11-27 · Durum: Taslak (Kapı 1 onayı bekliyor) · Hazırlayan: urun-stratejisti

> Bu doküman pazar araştırmasından önce yazıldı. Rakip ve fiyat bilgileri `TAHMİN:` etiketli; `docs/02-pazar/pazar-raporu.md` çıktıktan sonra güncellenecek.

## 1. Değer önerisi
**Düğün yapan çiftler için**, davetlilerin çektiği yüzlerce fotoğraf ve videonun WhatsApp gruplarına, farklı telefonlara ve kaybolan Instagram hikâyelerine dağılması problemini, **tek bir QR kodla katılınan, sadece davetlilere açık, özel bir düğün akışı** ile çözüyoruz. Herkes çektiğini aynı yere atar, çift düğünden sonra tamamını tek seferde orijinal kalitede indirir.

Alternatiflerden farkı:
- **WhatsApp grubu:** fotoğrafları sıkıştırır, kalabalık grupta kaybolur, düğün bitince dağılır. Murevet orijinal kaliteyi korur ve albüm olarak kalır.
- **Instagram/hashtag:** herkese açıktır, davetliler arasında yaşlı akrabalar vardır, hikâyeler 24 saatte silinir. Murevet özeldir ve kalıcıdır.
- **Google Fotoğraflar paylaşılan albüm:** sosyal yanı (beğeni, yorum, düğün bilgisi, program) yoktur, Türkçe düğün kültürüne (kına, nikâh, düğün ayrı etkinlikler) göre kurgulanmamıştır.
- **Yabancı düğün fotoğraf uygulamaları** (TAHMİN: The Guest, WedShoots, Joy, Zola, POV vb.): Türkçe değil ya da Türkiye fiyatlamasına uygun değil; Türk düğününün çok etkinlikli yapısını (kına, nişan, nikâh, düğün) desteklemiyor. Pazar ajanı doğrulayacak.

**Konumlandırma önerisi:** Murevet, genel bir sosyal ağ değil, **düğün başına kurulan özel bir paylaşım alanı**dır. Bu seçim MVP'yi küçültür, moderasyon riskini azaltır ve KVKK yükünü hafifletir (bkz. Açık soru 1).

## 2. Personalar
| Persona | Hedefi | Acısı | Kullanım sıklığı |
|---|---|---|---|
| **Gelin/damat (düğün sahibi)**, 25-35 yaş, akıllı telefonu aktif kullanan | Düğünün tüm anılarını tek yerde, orijinal kalitede toplamak; davetlileri bilgilendirmek | Fotoğraflar 50 farklı telefonda; "bana da atar mısın" mesajları; hazırlık stresi içinde uğraşacak vakit yok | Düğünden 2-4 hafta önce kurulum; düğün günü ve sonraki 2 hafta yoğun; sonra ara ara anı bakma |
| **Davetli (genç)**, 18-40 yaş | Çektiğini kolayca paylaşmak, başkalarının çektiklerini görmek, kendini fotoğraflarda bulmak | Hangi gruba atacağını bilmemek; uzun kayıt süreçleri | Düğün günü yoğun (5-30 yükleme), sonraki hafta göz atma |
| **Davetli (orta yaş/yaşlı akraba)**, 45+ yaş | Düğünü takip etmek, fotoğraflara bakmak, konum ve saat bilgisine ulaşmak | Yeni uygulama indirmekten ve şifre oluşturmaktan çekinmek | Düğün öncesi bilgi bakma, düğün sonrası fotoğraf bakma |

VARSAYIM: Düğün organizatörü/salon personası MVP'de yok; organizatör iş birlikleri dağıtım kanalı olarak pazarlama ajanında ele alınacak, ürün içi organizatör paneli v2'de değerlendirilecek.

## 3. Kullanım senaryoları
1. **Gelin** olarak düğünümü 5 dakikada oluşturmak ve QR kod kartını masalara koymak istiyorum, böylece davetliler tek taramayla katılır.
2. **Gelin** olarak kına, nikâh ve düğünü aynı düğün sayfasında ayrı etkinlikler olarak göstermek istiyorum, böylece fotoğraflar etkinliğe göre ayrışır ve davetliler saat/konuma ulaşır.
3. **Davetli** olarak QR'ı tarayıp birkaç dokunuşla giriş yapmak ve galerimden çoklu fotoğraf/video yüklemek istiyorum, böylece çektiklerimi çifte ulaştırırım.
4. **Davetli** olarak düğün akışında diğerlerinin paylaşımlarını görmek, beğenmek ve yorum yapmak istiyorum, böylece düğünü birlikte yaşarız.
5. **Gelin** olarak düğün sonrası tüm fotoğraf ve videoları tek seferde orijinal kalitede indirmek istiyorum, böylece kalıcı arşivim olur.
6. **Gelin** olarak uygunsuz bir paylaşımı gizlemek veya bir kişiyi düğünden çıkarmak istiyorum, böylece düğün alanı güvenli kalır.
7. **Davetli** olarak rahatsız edici bir içeriği şikayet etmek veya bir kişiyi engellemek istiyorum.
8. **Herhangi bir kullanıcı** olarak hesabımı ve verilerimi silmek istiyorum (Play ve KVKK zorunluluğu).

## 4. MVP kapsamı (MoSCoW)
MVP yalnızca **Must** satırlarını içerir. Hedef: tek mobil geliştirici + ajan ekibiyle 8-10 haftada kapalı teste çıkmak (TAHMİN).

### Must (MVP)
| # | Özellik | Senaryo | Not |
|---|---|---|---|
| M1 | **Giriş:** Google ile giriş + e-posta bağlantısıyla giriş | 3 | Şifresiz. Telefon/SMS girişi SMS maliyeti nedeniyle Should'a alındı. |
| M2 | **Düğün oluşturma:** çift adları, tarih, kapak fotoğrafı, kısa mesaj | 1 | Bir kullanıcı birden çok düğün oluşturabilir/katılabilir. |
| M3 | **Etkinlikler:** düğüne bağlı 1-5 etkinlik (kına, nişan, nikâh, düğün…) ad, tarih-saat, mekân adı, harita bağlantısı | 2 | Harita gömülü değil, Google Haritalar bağlantısı açılır. |
| M4 | **Davet:** düğün başına QR kod ve paylaşılabilir bağlantı (deep link); QR'ı yazdırılabilir PNG olarak indirme | 1, 3 | Bağlantıyı bilen katılır; sahip isterse bağlantıyı yeniler. |
| M5 | **Katılım:** QR/bağlantı → giriş → ad soyad → düğüne katıl | 3 | Uygulama yüklü değilse bağlantı Play mağazasına yönlendirir. |
| M6 | **Paylaşım:** galeriden çoklu fotoğraf (en fazla 20) ve kısa video (en fazla 60 sn) seçip yükleme, isteğe bağlı açıklama, etkinlik seçimi | 3 | Android Fotoğraf Seçici kullanılır (geniş medya izni yok). Arka planda yükleme, kesilirse devam. Uygulama içi kamera Should. |
| M7 | **Düğün akışı:** ters kronolojik akış, etkinliğe göre filtre, tam ekran görüntüleme | 4 | Sadece düğün üyeleri görür. |
| M8 | **Beğeni ve yorum** | 4 | Yorumlar düz metin, tek seviye. |
| M9 | **Toplu indirme:** düğün sahibi tüm medyayı orijinal kalitede indirir | 5 | MVP'de sunucuda ZIP hazırlanıp indirme bağlantısı verilir (TAHMİN: Cloud Function). |
| M10 | **Roller:** sahip (çift, en fazla 2 kişi), davetli | 6 | Sahip ikinci sahibi (eşini) davet eder. |
| M11 | **Moderasyon (Play UGC zorunlu):** paylaşmadan önce içerik kurallarını kabul, her gönderi/yorumda şikayet, kullanıcı engelleme, sahip için gizleme/kaldırma ve kişiyi düğünden çıkarma, şikayet kuyruğu | 6, 7 | `ugc-moderasyon` skill'i. Kuyruk MVP'de Firestore koleksiyonu + e-posta bildirimi. |
| M12 | **Bildirimler:** yeni paylaşım özeti (toplu, saatte en fazla 1), yoruma yanıt, etkinlik hatırlatması (1 gün önce) | 2, 4 | FCM. Bildirim izni Android 13+ çalışma zamanında istenir. |
| M13 | **Profil ve hesap silme:** ad, profil fotoğrafı; uygulama içi hesap silme + web'den silme sayfası | 8 | Play hesap silme şartı (DOĞRULA). |
| M14 | **Yasal ekranlar:** KVKK aydınlatma metni, kullanım koşulları, gizlilik politikası bağlantıları | 8 | Hukuki metinler taslak, Kapı 3'te hukukçu onayı. |
| M15 | **Türkçe arayüz** | tümü | Metinler en baştan yerelleştirme dosyasında (İngilizce kolay eklensin). |
| M16 | **Ücretsiz plan limitleri:** düğün başına davetli ve depolama sınırı | 5 | Gelir modeline bağlı (bkz. §7). Limit aşılınca bilgilendirme, ödeme MVP'de yok. |
| M17 | **Çökme raporu ve temel analitik** | — | Crashlytics + Analytics, KPI olayları (§6). |

### Should (MVP+1, yayından sonraki ilk 4-6 hafta)
| Özellik | Not |
|---|---|
| Düğün başına premium paket satın alma (Google Play Faturalandırma) | Gelir modeli onaylanırsa. Dijital içerik olduğu için Play Faturalandırma zorunlu (DOĞRULA). |
| Telefon numarasıyla (SMS) giriş | Yaşlı davetliler için kolaylık; SMS maliyeti ölçülerek. |
| Uygulama içi kamera ile çek-paylaş | |
| İngilizce arayüz | Yurt dışındaki akrabalar için. |
| Kişinin kendi yüklediklerini ve beğendiklerini indirmesi | |
| Albüm/öne çıkanlar: sahip seçtiklerini ayrı albüme alır | |

### Could (v2)
| Özellik | Not |
|---|---|
| Uygulama indirmeden web'den yükleme (misafir yükleme sayfası) | Katılımı ciddi artırabilir; web + güvenlik yükü nedeniyle MVP dışı. Pazar verisine göre öne alınabilir. |
| Yüz tanıma ile "benim olduğum fotoğraflar" | Biyometrik veri: KVKK özel nitelikli veri, açık rıza ve ciddi risk. |
| Anı defteri / sesli-yazılı tebrik mesajları | |
| Düğün sonrası basılı albüm siparişi | Gelir kanalı olabilir. |
| Organizatör/salon paneli (çoklu düğün yönetimi) | B2B gelir modeli. |
| iOS sürümü | Flutter seçilirse aynı kod tabanından. |
| Otomatik içerik ön taraması (Cloud Vision SafeSearch) | Maliyet ve KVKK değerlendirmesi sonrası. |

### Won't (bu sürümde kesinlikle yok)
Bkz. §5.

## 5. Kapsam dışı
- **Herkese açık profil, takip etme, keşfet akışı:** Murevet genel bir sosyal ağ değil; içerik yalnızca düğün üyelerine görünür.
- **Düğünler arası mesajlaşma ve özel mesaj (DM):** Moderasyon ve güvenlik yükü yüksek, değer önerisine katkısı düşük.
- **Canlı yayın, hikâyeler, filtre/efekt editörü.**
- **Düğün planlama araçları** (bütçe, tedarikçi bulma, davetiye/RSVP yönetimi, oturma planı). RSVP v2'de değerlendirilebilir.
- **Altın/para takma, hediye listesi, ödeme alma:** Finansal düzenleme ve Play finans politikası riski.
- **iOS ve web uygulaması** (MVP'de yalnızca Android).
- **Reklam:** Düğün gibi özel bir anda reklam deneyimi bozar; Play'de reklam beyanı ve çocuk/aile politikası yükü ekler.

## 6. KPI'lar
| Ölçüt | Tanım | Hedef (ilk 90 gün, TAHMİN) |
|---|---|---|
| Oluşturulan düğün | Kurulumu tamamlanan (en az 1 etkinlik + davet bağlantısı oluşturulmuş) düğün sayısı | 50 |
| Aktivasyon (düğün) | Oluşturulan düğünlerden en az 10 davetlinin katıldığı ve en az 50 medya yüklenen düğün oranı | %40 |
| Davetli katılım oranı | Katılan davetli / düğün sahibinin girdiği tahmini davetli sayısı | %25 |
| Yükleyen davetli oranı | En az 1 paylaşım yapan / katılan davetli | %50 |
| Düğün başına medya | Aktif düğünlerde ortalama yüklenen fotoğraf + video | 200 |
| Toplu indirme oranı | Düğün sonrası 30 gün içinde toplu indirme yapan sahip / aktif düğün | %70 |
| Tavsiye (organik büyüme) | Davetli olarak katılıp sonradan kendi düğününü oluşturan kullanıcı | İzlenir (hedef yok, uzun vadeli sinyal) |
| Kalite | Çökme içermeyen kullanıcı oranı | ≥ %99,5 |

VARSAYIM: Düğünlük bir ürün olduğu için "haftalık aktif kullanıcı" ana ölçüt değildir; ölçüm birimi **düğün**dür.

## 7. Gelir modeli
Seçenekler:
| Model | Artı | Eksi |
|---|---|---|
| A. Tamamen ücretsiz (şimdilik) | Benimsemeyi hızlandırır | Video depolama maliyeti kullanıcıyla büyür, gelir yok |
| **B. Düğün başına tek seferlik premium (önerilen)** | Düğün tek seferlik bir olay; çiftler düğün harcamasına alışkın; abonelik yorgunluğu yok | Tekrar gelir yok; fiyat hassasiyeti (TAHMİN) |
| C. Abonelik | Tekrar eden gelir | Düğün yılda bir kez olmaz, kullanıcı için anlamsız |
| D. Organizatör/salon aboneliği (B2B) | Büyük hacim, dağıtım kanalı | Satış eforu, ürün içi panel gerekir; v2 |
| E. Reklam | | Deneyimi bozar, kapsam dışı |

**Öneri:** B + ileride D. Ücretsiz planda düğün başına sınırlı davetli ve depolama (TAHMİN: 50 davetli, 2 GB veya 500 medya, video 30 sn), premiumda sınırsız davetli, daha uzun video, 1 yıl saklama ve toplu indirme. Fiyat pazar araştırması sonrası belirlenecek (TAHMİN: 500-1.500 TL aralığı, DOĞRULA).
**MVP'de ödeme alınmaz**; limitler uygulanır ve ilk düğünlerde premium "lansman hediyesi" olarak açılır. Play Faturalandırma MVP+1'de eklenir. Böylece MVP küçük kalır, gerçek kullanımdan maliyet ve istek verisi toplanır.

Maliyet notu: Ana maliyet video depolama ve indirme trafiği (Firebase Storage / Supabase Storage). Video süresi limiti, istemci tarafı sıkıştırma ve düğün başına saklama süresi bu yüzden MVP'de var (TAHMİN; backend ajanı düğün başına maliyeti hesaplayacak).

## 8. Varsayımlar
- VARSAYIM: Düğünler özeldir; içerik yalnızca katılan üyelere görünür (bkz. Açık soru 1).
- VARSAYIM: Öncelikli pazar Türkiye, arayüz Türkçe; İngilizce MVP+1.
- VARSAYIM: Bir düğünde 100-500 davetli, 200-2.000 medya olur (TAHMİN).
- VARSAYIM: Davetlilerin önemli kısmı uygulamayı yalnızca o düğün için indirir; bu yüzden katılım akışı (QR → giriş → yükleme) 60 saniyenin altında olmalı.
- VARSAYIM: Teknoloji Flutter + Firebase (öneri: `docs/kararlar/001-teknoloji.md`, Kapı 2'de onaylanacak).
- VARSAYIM: Uygulama adı "Murevet"; Play ve TÜRKPATENT çakışma kontrolü yapılmadı (Kapı 1 maddesi).

## 9. Açık sorular (karar: Can)
- [ ] **1. Konumlandırma:** Murevet "düğün başına özel paylaşım alanı" mı olsun (öneri), yoksa herkese açık profiller ve keşfet akışı olan genel bir düğün sosyal ağı mı? Öneri MVP'yi ve riskleri ciddi küçültür.
- [ ] **2. Gelir modeli:** Düğün başına tek seferlik premium (MVP'de ödemesiz, limitlerle) önerisine onay.
- [ ] **3. Play geliştirici hesabı:** Şirketin var mı? Yoksa bireysel hesap öneriyoruz (kapalı test şartı planlamaya dahil). Bkz. `docs/kararlar/002-play-hesabi.md`.
- [ ] **4. Teknoloji:** Flutter + Firebase önerisi (`docs/kararlar/001-teknoloji.md`). Kapı 2'de resmî onay; itirazın yoksa tasarım aşaması bu varsayımla ilerler.
- [ ] **5. Pazar:** Türkiye öncelikli, yurt dışındaki Türk toplulukları (Almanya, Hollanda vb.) ikincil hedef. Onay.

## Sonraki adımlar
1. `pazar-arastirmaci`: rakipler, fiyatlar, Play yorumlarındaki şikayetler, isim çakışması → `docs/02-pazar/pazar-raporu.md`.
2. Bu doküman pazar verisiyle güncellenir, Kapı 1 listesi doldurulup Can'a sunulur.
3. Kapı 1 sonrası: `ux-ui-tasarimci` (akışlar ve ekranlar), `backend-gelistirici` (veri modeli ve maliyet), `guvenlik-kvkk` (veri envanteri).
