# Veri Modeli ve Yetki Tasarımı (MVP, ilk dalga)
Sürüm: v0.1 · Tarih: 2026-11-27 · Hazırlayan: backend-gelistirici
Kapsam: ön modül, kodla katılım, A. Katılımcı Organizasyonu, B. Anı Paylaşımı, yönetim paneli.

## İlkeler
1. **Her düğün kapalı bir alan.** Bir kullanıcı sadece üyesi olduğu düğünün verisini okuyabilir. Düğünler arası sorgu yoktur.
2. **Yetki sunucudadır.** Modüllerin açık olup olmadığı ve süreleri Firestore/Storage güvenlik kurallarında `request.time` ile kontrol edilir; uygulama arayüzü sadece yansıtır.
3. **Kodlar istemciye okunmaz.** Kod koleksiyonu tamamen sunucuya özeldir; katılım sadece `joinWithCode` fonksiyonuyla yapılır (deneme sınırı ile).
4. **Düğünü ve modülleri yalnızca Lotus yöneticileri açar.** Yönetici yetkisi Firebase Auth özel alanıdır (`admin: true`), sadece sunucudan verilir.
5. **Kişisel veri ayrımı:** e-posta gibi özel bilgiler sadece kullanıcının kendi `users/{uid}` belgesindedir. Düğün içinde sadece görünen ad görünür.

## Koleksiyonlar
### `weddings/{weddingId}` (yazma: sadece sunucu/yönetici)
| Alan | Tip | Açıklama |
|---|---|---|
| title | string | "Ayşe & Mehmet" |
| coverPath | string? | Storage yolu |
| status | `active` \| `closed` | `closed` ise kimse yazamaz |
| requireApproval | bool | Kodla gelen davetli onay bekler mi |
| modules.katilimci | map {enabled, start, end} | A modülü: açık olduğu zaman aralığı |
| modules.paylasim | map {enabled, uploadStart, uploadEnd} | B modülü: yükleme penceresi. Görüntüleme süresizdir (düğün sonrası buluttan erişim, KARAR) |
| contractRef | string? | Lotus iç sözleşme numarası |
| createdAt | timestamp | |

### `weddings/{weddingId}/members/{uid}`
| Alan | Tip | Açıklama |
|---|---|---|
| role | `owner` \| `guest` | Sadece sunucu atar |
| status | `active` \| `pending` \| `removed` | Sahip onaylar/çıkarır |
| displayName | string (1-60) | Kullanıcı kendi adını değiştirebilir |
| joinedAt | timestamp | |

### Modül A: Katılımcı Organizasyonu
- `weddings/{w}/events/{eventId}`: name, startAt, venueName, address?, mapUrl? — **sahip** yazar, aktif üyeler okur.
- `weddings/{w}/announcements/{id}`: text, createdAt, authorUid — **sahip** yazar.
- `weddings/{w}/rsvps/{uid}`: answer (`yes`/`no`/`maybe`), headcount (1-10), note?, updatedAt — her üye **kendi** belgesini, A modülü penceresi açıkken yazar; sahip hepsini okur, davetli sadece kendisininkini.

### Modül B: Anı Paylaşımı
- `weddings/{w}/posts/{postId}`: authorUid, authorName, mediaPath, mediaType (`image`/`video`), caption?, eventId?, batchId?, createdAt, status (`visible`/`hidden`), likeCount, commentCount.
  - Bir gönderi = bir medya. Çoklu seçim aynı `batchId` ile birden çok gönderi oluşturur (kuralların her öğeyi doğrulayabilmesi için).
  - Oluşturma: aktif üye + yükleme penceresi açık. Sahip `status` değiştirebilir. Yazar silebilir. Sayaçları sadece sunucu günceller.
- `.../posts/{p}/likes/{uid}`: uid, createdAt. Üye kendi beğenisini ekler/siler.
- `.../posts/{p}/comments/{c}`: authorUid, authorName, text (1-500), createdAt, status.
- `weddings/{w}/reports/{id}`: reporterUid, targetType (`post`/`comment`/`member`), targetId, reason, createdAt — üye oluşturur, sahip ve yönetici okur.

### Diğer
- `users/{uid}`: displayName, email?, createdAt — sadece sahibi okur/yazar.
- `users/{uid}/blocks/{blockedUid}`: createdAt — sadece sahibi.
- `users/{uid}/memberships/{weddingId}`: weddingId, title, role, joinedAt — sunucu yazar; kullanıcı "düğünlerim" listesi için okur.
- `weddings/{w}/private/invite`: guestCode, ownerCode — sadece sahip ve yönetici okur, sunucu yazar.
- `codes/{code}` (istemciye kapalı): weddingId, type (`owner`/`guest`), active, createdAt.
- `joinAttempts/{uid}` (istemciye kapalı): deneme sayacı, kaba kuvvet koruması.

## Storage
`weddings/{weddingId}/posts/{postId}/{dosya}`: yazma aktif üye + yükleme penceresi açık; görsel ≤ 15 MB, video ≤ 150 MB, sadece `image/*` ve `video/*`. Okuma: düğünün aktif üyeleri.

## Sunucu fonksiyonları (Cloud Functions, TypeScript)
| Fonksiyon | Kim çağırır | Ne yapar |
|---|---|---|
| `joinWithCode` | Giriş yapmış kullanıcı | Kodu doğrular, deneme sınırı uygular, üyelik oluşturur (rol koda göre) |
| `adminCreateWedding` | Yönetici | Düğün belgesi ve sahip + davetli kodlarını oluşturur |
| `adminUpdateModules` | Yönetici | Modül açık/kapalı ve sürelerini günceller |
| `adminRotateCode` | Yönetici veya sahip (sadece davetli kodu) | Eski kodu kapatır, yenisini üretir |
| `onLikeWrite`, `onCommentWrite` | Tetikleyici | Sayaçları günceller |
| `deleteAccount` | Kullanıcı | Hesabı ve kişisel verilerini siler (Play + KVKK) |

## Açık noktalar
- Düğün sonrası saklama süresi (C. Arşiv modülü kararıyla birlikte).
- Firebase bölgesi: VARSAYIM `europe-west1` (KVKK yurt dışı aktarım değerlendirmesi `guvenlik-kvkk` ajanında).
