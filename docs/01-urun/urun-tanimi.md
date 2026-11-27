# Ürün Tanımı: Murevet
Sürüm: v0.4 · Tarih: 2026-11-27 · Durum: Taslak (Kapı 1 onayı bekliyor) · Hazırlayan: urun-stratejisti

> Bu doküman pazar araştırmasından önce yazıldı. Rakip ve fiyat bilgileri `TAHMİN:` etiketli; `docs/02-pazar/pazar-raporu.md` çıktıktan sonra güncellenecek.
>
> v0.2: paralel yazılan iki taslak (PR #2 ve #3) birleştirildi ve Can'ın 2026-11-27 kararları işlendi.
> v0.4: Can'ın satış modeli işlendi: uygulama içi satış yok, ofiste sözleşmeli modül paketleri, süreli modüller, kodsuz kullanıcı için ön modül ve Lotus yönetim paneli eklendi.
> v0.3: pazar raporu (`docs/02-pazar/pazar-raporu.md`) eklendi; fiyatlar ve rakip bilgisi güncellendi. **En büyük risk:** rakiplerin çoğu uygulama indirmeden tarayıcıdan katılım sunuyor; Murevet'in uygulama + kod modeli ayrıcalık sağlar ama katılımı düşürebilir. Kapalı testte ölçülecek.

## Can'ın kararları (2026-11-27)
| Konu | Karar |
|---|---|
| Konumlandırma | **Her düğün kapalı bir sistem.** Erişim yalnızca düğün sahibinin verdiği kodla. Farklı düğünlerin davetlileri asla bir araya gelmez. Değer önerisinin merkezi **ayrıcalık**. |
| Katılım | Davetliler uygulamayı indirir ve **kodla katılır** (Google Classroom'daki sınıf kodu gibi). |
| Ödeme | **Uygulama içinde satış yok.** İndirme ücretsiz. Düğün sahibi Lotus Sport Teknoloji ile ofiste **sözleşme** imzalar ve **modül paketi** satın alır (örnek: tüm hizmetler ~100.000 TL, sadece katılımcı organizasyonu ~50.000 TL). Davetli hiçbir zaman ödemez. |
| İsim | **Murevet** kalıyor. |
| Play hesabı | **Kurumsal**, Exereyes ile aynı Lotus Sport Teknoloji hesabı. Konu kapandı. |
| Uygulama yapısı | Uygulama **tüm modüllerle** yapılır; her düğünde sadece sözleşmedeki modüller, belirlenen süre boyunca (ör. etkinlik günü) açılır. Kodu olmayan kullanıcı **ön modülde** kalır, asıl uygulamaya erişemez. |

## 1. Değer önerisi
**Düğün yapan çiftler için**, davetlilerin çektiği yüzlerce fotoğraf ve videonun WhatsApp gruplarına, farklı telefonlara ve kaybolan Instagram hikâyelerine dağılması problemini, **yalnızca düğün sahibinin verdiği kodla girilebilen, her düğün için ayrı ve kapalı bir paylaşım alanı** ile çözüyoruz. Ayrıcalık ürünün özüdür: bir düğünün alanı, o düğünün davetlileri dışında kimseye görünmez ve hiçbir düğün başka bir düğünle temas etmez. Herkes çektiğini aynı yere atar, çift düğünden sonra tamamını tek seferde orijinal kalitede indirir.

Alternatiflerden farkı:
- **WhatsApp grubu:** fotoğrafları sıkıştırır, kalabalık grupta kaybolur, düğün bitince dağılır. Murevet orijinal kaliteyi korur ve albüm olarak kalır.
- **Instagram/hashtag:** herkese açıktır, davetliler arasında yaşlı akrabalar vardır, hikâyeler 24 saatte silinir. Murevet özeldir ve kalıcıdır.
- **Google Fotoğraflar paylaşılan albüm:** sosyal yanı (beğeni, yorum, düğün bilgisi, program) yoktur, Türkçe düğün kültürüne (kına, nikâh, düğün ayrı etkinlikler) göre kurgulanmamıştır.
- **Yabancı düğün fotoğraf uygulamaları** (TAHMİN: The Guest, WedShoots, Joy, Zola, POV vb.): Türkçe değil ya da Türkiye fiyatlamasına uygun değil; Türk düğününün çok etkinlikli yapısını (kına, nişan, nikâh, düğün) desteklemiyor. Pazar ajanı doğrulayacak.

**Konumlandırma (KARAR):** Murevet genel bir sosyal ağ değil, **her düğün için kurulan kapalı ve ayrıcalıklı bir alan**dır. Model Google Classroom'a benzer: sahip alanı kurar, kod dağıtır, davetli uygulamayı indirip kodu girerek katılır. Bu seçim MVP'yi küçültür, moderasyon riskini azaltır ve KVKK yükünü hafifletir.

## 2. Personalar
| Persona | Hedefi | Acısı | Kullanım sıklığı |
|---|---|---|---|
| **Gelin/damat (düğün sahibi, sözleşmeyi imzalayan)**, 25-35 yaş, akıllı telefonu aktif kullanan | Düğünün tüm anılarını ve davetlilerini tek, ayrıcalıklı bir alanda yönetmek | Fotoğraflar 50 farklı telefonda; davetli takibi dağınık; hazırlık stresi | Sözleşme sonrası kurulum; düğün günü yoğun; sonra arşiv |
| **Davetli (genç, hiçbir zaman ödemez)**, 18-40 yaş | Çektiğini kolayca paylaşmak, başkalarının çektiklerini görmek, kendini fotoğraflarda bulmak | Hangi gruba atacağını bilmemek; uzun kayıt süreçleri | Düğün günü yoğun (5-30 yükleme), sonraki hafta göz atma |
| **Davetli (orta yaş/yaşlı akraba)**, 45+ yaş | Düğünü takip etmek, fotoğraflara bakmak, konum ve saat bilgisine ulaşmak | Yeni uygulama indirmekten ve şifre oluşturmaktan çekinmek | Düğün öncesi bilgi bakma, düğün sonrası fotoğraf bakma |
| **Lotus operasyon ekibi** (iç kullanıcı) | Sözleşmeyi sisteme işlemek: düğünü açmak, modülleri ve süreleri tanımlamak, kodları üretmek | Elle takip edilen sözleşmeler, hatalı açılan modüller | Her yeni sözleşmede ve düğün günü destek |

VARSAYIM: Düğün organizatörü/salon personası MVP'de yok; organizatör iş birlikleri dağıtım kanalı olarak pazarlama ajanında ele alınacak, ürün içi organizatör paneli v2'de değerlendirilecek.

## 3. Kullanım senaryoları
1. **Lotus operasyon** olarak imzalanan sözleşmeyi yönetim panelinde düğüne çevirmek (çift, tarih, etkinlikler, paketteki modüller, açık kalma süreleri) ve çifte sahip kodu vermek istiyorum. **Gelin** olarak sahip koduyla düğünüme girip davetli kodunu (yazılı kod + QR) davetiyeye ve masalara koymak istiyorum.
2. **Gelin** olarak kına, nikâh ve düğünü aynı düğün sayfasında ayrı etkinlikler olarak göstermek istiyorum, böylece fotoğraflar etkinliğe göre ayrışır ve davetliler saat/konuma ulaşır.
3. **Davetli** olarak uygulamayı indirip giriş yapmak, düğün kodunu yazmak veya QR'ı okutmak ve galerimden çoklu fotoğraf/video yüklemek istiyorum, böylece çektiklerimi çifte ulaştırırım.
4. **Davetli** olarak düğün akışında diğerlerinin paylaşımlarını görmek, beğenmek ve yorum yapmak istiyorum, böylece düğünü birlikte yaşarız.
5. **Gelin** olarak düğün sonrası tüm fotoğraf ve videoları tek seferde orijinal kalitede indirmek istiyorum, böylece kalıcı arşivim olur.
6. **Gelin** olarak kodu yenilemek, katılımları onaya bağlamak, uygunsuz bir paylaşımı gizlemek veya bir kişiyi düğünden çıkarmak istiyorum, böylece alan sadece benim davetlilerime ait kalır.
7. **Davetli** olarak rahatsız edici bir içeriği şikayet etmek veya bir kişiyi engellemek istiyorum.
8. **Herhangi bir kullanıcı** olarak hesabımı ve verilerimi silmek istiyorum (Play ve KVKK zorunluluğu).
9. **Kodu olmayan bir kullanıcı** olarak uygulamayı açtığımda Murevet'in ne olduğunu görmek ve kodumu girebileceğim ekrana ulaşmak istiyorum; asıl uygulamanın içini göremem.
10. **Davetli** olarak bir modülün süresi dolduğunda (ör. paylaşım düğün günü kapandığında) ne olduğunu anlamak ve izin verilen kısımlara (ör. arşivi görüntüleme) erişmeye devam etmek istiyorum.

## 4. MVP kapsamı (MoSCoW)
MVP yalnızca **Must** satırlarını içerir. Hedef: tek mobil geliştirici + ajan ekibiyle 8-10 haftada kapalı teste çıkmak (TAHMİN).

### Must (MVP)
| # | Özellik | Senaryo | Not |
|---|---|---|---|
| M0 | **Ön modül (giriş kapısı):** kodu olmayan kullanıcının gördüğü tek alan: Murevet tanıtımı, "Kodum var" (kod yaz / QR okut / bağlantıdan otomatik), gizlilik ve kullanım koşulları. Asıl uygulamaya, menülere veya herhangi bir düğün içeriğine erişim yok | 9 | Uygulama içinde fiyat veya satın alma yönlendirmesi yok (Play ödeme politikası, DOĞRULA). Play inceleme ekibi için **demo kodu** verilir (Uygulama erişimi beyanı). |
| M1 | **Giriş:** Google ile giriş + e-posta bağlantısıyla giriş | 3 | Şifresiz. Telefon/SMS girişi SMS maliyeti nedeniyle Should'a alındı. |
| M2 | **Yönetim paneli (Lotus iç kullanımı):** sözleşmeye göre düğün açma, çift bilgileri, etkinlikler, **paket ve modül atama, modül açık kalma pencereleri**, sahip ve davetli kodlarını üretme/iptal etme, düğünü kapatma | 1 | VARSAYIM: MVP'de basit bir web paneli (Firebase Hosting) veya uygulama içinde "yönetici" rolü. Çift düğünü uygulamada kendisi oluşturmaz. |
| M3 | **Etkinlikler:** düğüne bağlı 1-5 etkinlik (kına, nişan, nikâh, düğün…) ad, tarih-saat, mekân adı, harita bağlantısı | 2 | Harita gömülü değil, Google Haritalar bağlantısı açılır. |
| M4 | **Kodlar:** iki tür kod: **sahip kodu** (çifte, sahip rolünü açar) ve **davetli kodu** (6-8 karakter, karışan harfler yok: 0/O, 1/I); aynı kodu taşıyan QR ve bağlantı; QR'ı yazdırılabilir PNG olarak indirme | 1, 3 | Kodu yalnızca Lotus (sahip kodu) ve çift (davetli kodu) dağıtır. Kod yenileme ve kapatma, deneme hız sınırı (kaba kuvvet koruması). |
| M5 | **Katılım (Classroom modeli):** uygulamayı indir → ön modül → kodu yaz / QR okut / bağlantıdan otomatik → giriş (Google veya e-posta) → ad soyad → düğüne katıl | 3 | Bağlantı uygulama yüklü değilse Play'e yönlendirir ve kurulumdan sonra kodu otomatik doldurur. Bir kullanıcı birden çok düğüne katılabilir ama her düğün ayrı alandır; düğünler arası hiçbir içerik, kişi listesi veya öneri görünmez. |
| M6 | **Paylaşım:** galeriden çoklu fotoğraf (en fazla 20) ve kısa video (en fazla 60 sn) seçip yükleme, isteğe bağlı açıklama, etkinlik seçimi | 3 | Android Fotoğraf Seçici kullanılır (geniş medya izni yok). Arka planda yükleme, kesilirse devam. Uygulama içi kamera Should. |
| M7 | **Düğün akışı:** ters kronolojik akış, etkinliğe göre filtre, tam ekran görüntüleme | 4 | Sadece düğün üyeleri görür. |
| M8 | **Beğeni ve yorum** | 4 | Yorumlar düz metin, tek seviye. |
| M9 | **Toplu indirme:** düğün sahibi tüm medyayı orijinal kalitede indirir | 5 | MVP'de sunucuda ZIP hazırlanıp indirme bağlantısı verilir (TAHMİN: Cloud Function). |
| M10 | **Roller ve erişim kontrolü:** sahip (çift, en fazla 2 kişi), davetli; isteğe bağlı **katılım onayı** (sahip açarsa kodla gelen herkes onay bekler); davetli listesi ve çıkarma | 6 | Sahip ikinci sahibi (eşini) davet eder. Ayrıcalık için katılım onayı varsayılan olarak açık önerilir (VARSAYIM). |
| M11 | **Moderasyon (Play UGC zorunlu):** paylaşmadan önce içerik kurallarını kabul, her gönderi/yorumda şikayet, kullanıcı engelleme, sahip için gizleme/kaldırma ve kişiyi düğünden çıkarma, şikayet kuyruğu | 6, 7 | `ugc-moderasyon` skill'i. Kuyruk MVP'de Firestore koleksiyonu + e-posta bildirimi. |
| M12 | **Bildirimler:** yeni paylaşım özeti (toplu, saatte en fazla 1), yoruma yanıt, etkinlik hatırlatması (1 gün önce) | 2, 4 | FCM. Bildirim izni Android 13+ çalışma zamanında istenir. |
| M13 | **Profil ve hesap silme:** ad, profil fotoğrafı; uygulama içi hesap silme + web'den silme sayfası | 8 | Play hesap silme şartı (DOĞRULA). |
| M14 | **Yasal ekranlar:** KVKK aydınlatma metni, kullanım koşulları, gizlilik politikası bağlantıları | 8 | Hukuki metinler taslak, Kapı 3'te hukukçu onayı. |
| M15 | **Türkçe arayüz** | tümü | Metinler en baştan yerelleştirme dosyasında (İngilizce kolay eklensin). |
| M16 | **Modül ve süre yetkileri:** her düğünde sadece sözleşmedeki modüller görünür; her modülün başlangıç-bitiş zamanı vardır (ör. paylaşım etkinlik günü 08:00 - ertesi gün 06:00). Süre bitince modül salt okunur veya kapalı olur; davetliye net bir mesaj gösterilir | 10 | Yetkiler sunucuda (güvenlik kuralları) uygulanır, sadece arayüzde değil. Bkz. §7.1 modül listesi. |
| M17 | **Çökme raporu ve temel analitik** | — | Crashlytics + Analytics, KPI olayları (§6). |

### Should (MVP+1, yayından sonraki ilk 4-6 hafta)
| Özellik | Not |
|---|---|
| Yönetim panelinde sözleşme/fatura takibi ve raporlar (düğün başına kullanım, depolama) | Satış ofiste kaldığı için Play Faturalandırma gerekmez. |
| Telefon numarasıyla (SMS) giriş | Yaşlı davetliler için kolaylık; SMS maliyeti ölçülerek. |
| Uygulama içi kamera ile çek-paylaş | |
| İngilizce arayüz | Yurt dışındaki akrabalar için. |
| Kişinin kendi yüklediklerini ve beğendiklerini indirmesi | |
| Albüm/öne çıkanlar: sahip seçtiklerini ayrı albüme alır | |

### Could (v2)
| Özellik | Not |
|---|---|
| Uygulama indirmeden web'den yükleme (misafir yükleme sayfası) | Can'ın kararı uygulama + kod modeli; bu ancak kodla korunan bir web sayfası olarak ve pazar verisi katılımın düşük olduğunu gösterirse değerlendirilir. |
| Yüz tanıma ile "benim olduğum fotoğraflar" | Biyometrik veri: KVKK özel nitelikli veri, açık rıza ve ciddi risk. |
| Anı defteri / sesli-yazılı tebrik mesajları | |
| Düğün sonrası basılı albüm siparişi | Gelir kanalı olabilir. |
| Organizatör/salon paneli (çoklu düğün yönetimi) | B2B gelir modeli. |
| iOS sürümü | Flutter seçilirse aynı kod tabanından. |
| Otomatik içerik ön taraması (Cloud Vision SafeSearch) | Maliyet ve KVKK değerlendirmesi sonrası. |

### Won't (bu sürümde kesinlikle yok)
Bkz. §5.

## 5. Kapsam dışı
- **Herkese açık profil, takip etme, keşfet akışı, düğünler arası kişi önerisi:** Her düğün kapalıdır; içerik ve kişiler yalnızca o düğünün üyelerine görünür (KARAR).
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
**KARAR (Can):** Uygulama içinde satış yok, indirme ücretsiz. Düğün sahibi Lotus Sport Teknoloji ile **ofiste sözleşme** imzalar ve bir **modül paketi** alır. Uygulama tüm modüllerle geliştirilir; sözleşmeye göre her düğünde ilgili modüller, belirlenen süre boyunca açılır. Davetli hiçbir zaman ödemez.

Bu model ürünü düşük fiyatlı bir uygulama olmaktan çıkarıp **premium bir hizmet** olarak konumlandırır. Ayrıcalık algısı fiyatla da desteklenir. Pazar raporundaki uygulama içi fiyatlar (25-60 USD) bu modelle doğrudan karşılaştırılamaz.

### 7.1 Modüller (öneri)
| Modül | İçerik | Varsayılan açık kalma (VARSAYIM) |
|---|---|---|
| **A. Katılımcı Organizasyonu** | Davetli listesi ve kodla katılım, LCV (katılıyorum/katılamıyorum, kişi sayısı), etkinlik programı, konum ve harita, duyurular ve bildirimler, masa/oturma bilgisi | Sözleşmeden etkinlik sonuna kadar |
| **B. Anı Paylaşımı** | Fotoğraf/video yükleme, düğün akışı, beğeni ve yorum, etkinliğe göre filtre | Yükleme etkinlik günü; görüntüleme sonrasında belirli bir süre |
| **C. Arşiv** | Tüm medyayı orijinal kalitede toplu indirme, saklama süresi | Etkinlikten sonra sözleşmedeki süre (ör. 1 yıl) |
| **D. Canlı Ekran** (Should) | Salondaki ekranda onaylı paylaşımların canlı slaytı | Etkinlik günü |
| **E. Girişte QR kontrol** (Should) | Davetlinin salon girişinde kodunun/QR'ının okutulması, katılım sayımı | Etkinlik günü |
| **F. Anı Defteri** (Could) | Yazılı/sesli tebrik mesajları | Etkinlik günü + sonrası |

Kimlik, profil, moderasyon, hesap silme ve yasal ekranlar her pakette ortak çekirdektir.

### 7.2 Paket örnekleri (Can'ın örneklerinden)
| Paket | Modüller | Fiyat (Can'ın örneği, KDV belirtilmedi) |
|---|---|---|
| **Katılımcı Paketi** | A + çekirdek | ~50.000 TL |
| **Tam Paket** | A + B + C + D + E + çekirdek | ~100.000 TL |
| Ara paketler (isteğe bağlı) | Ör. B + C (sadece anı paylaşımı) | Lotus belirler |

### 7.3 Uygulama ve Play açısından sonuçlar
- Satış uygulama dışında, bir hizmet sözleşmesiyle yapıldığı için uygulama içi ödeme ve Play Faturalandırma gerekmez (DOĞRULA: Play ödeme politikası; uygulamada fiyat gösterme veya satın almaya yönlendirme yapılmamalı).
- Uygulama koda bağlı olduğu için Play incelemesinde **"Uygulama erişimi"** beyanı ve inceleyiciye çalışan bir **demo kodu** zorunlu.
- Modül yetkileri ve süreler sunucu tarafında uygulanmalı; uygulamadan atlatılamamalı.
- Sözleşme, fatura ve ödeme takibi MVP'de uygulama dışında (Lotus'un mevcut muhasebesi) kalır; yönetim paneli sadece düğünü ve modülleri yönetir.


## 8. Varsayımlar
- KARAR: Düğünler kapalıdır; içerik yalnızca kodla katılan üyelere görünür.
- VARSAYIM: Öncelikli pazar Türkiye, arayüz Türkçe; İngilizce MVP+1.
- VARSAYIM: Bir düğünde 100-500 davetli, 200-2.000 medya olur (TAHMİN).
- VARSAYIM: Davetlilerin önemli kısmı uygulamayı yalnızca o düğün için indirir; bu yüzden katılım akışı (QR → giriş → yükleme) 60 saniyenin altında olmalı.
- VARSAYIM: Teknoloji Flutter + Firebase (öneri: `docs/kararlar/001-teknoloji.md`, Kapı 2'de onaylanacak).
- KARAR: Uygulama adı "Murevet". Play ve TÜRKPATENT çakışma kontrolü pazar araştırmasında yapılacak.

## 9. Açık sorular (karar: Can)
- [x] **1. Konumlandırma:** Kapalı, kodla erişilen düğün alanı (Can, 2026-11-27).
- [x] **2. Kim öder:** Yalnızca düğün sahipleri (Can, 2026-11-27).
- [x] **2a. Satış modeli:** Ofiste sözleşme + modül paketi, uygulama içi satış yok (Can, 2026-11-27).
- [ ] **2b. Modül listesi:** §7.1'deki A-F modülleri ve varsayılan açık kalma süreleri doğru mu? Eksik bir hizmet var mı (ör. salonda personel, ekran kurulumu gibi uygulama dışı hizmetler pakete dahil mi)?
- [ ] **2c. Paylaşım süresi:** Etkinlik bitince davetliler fotoğrafları görmeye devam etsin mi (ör. 30 gün), yoksa sadece çift arşive mi erişsin?
- [x] **3. Play geliştirici hesabı:** Kurumsal, Lotus Sport Teknoloji (Can, 2026-11-27).
- [x] **3a.** Murevet, Exereyes ile aynı şirket Play hesabından yayınlanacak (Can, 2026-11-27).
- [ ] **4. Teknoloji:** Flutter + Firebase önerisi (`docs/kararlar/001-teknoloji.md`). Kapı 2'de resmî onay; itirazın yoksa tasarım aşaması bu varsayımla ilerler.
- [ ] **5. Pazar:** Türkiye öncelikli, yurt dışındaki Türk toplulukları (Almanya, Hollanda vb.) ikincil hedef. Onay.

## Sonraki adımlar
1. `pazar-arastirmaci`: rakipler, fiyatlar, Play yorumlarındaki şikayetler, isim çakışması → `docs/02-pazar/pazar-raporu.md`.
2. Bu doküman pazar verisiyle güncellenir, Kapı 1 listesi doldurulup Can'a sunulur.
3. Kapı 1 sonrası: `ux-ui-tasarimci` (akışlar ve ekranlar), `backend-gelistirici` (veri modeli ve maliyet), `guvenlik-kvkk` (veri envanteri).
