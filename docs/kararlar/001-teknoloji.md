# Karar 001: Mobil teknoloji ve backend
Tarih: 2026-11-27 · Durum: Önerildi · Karar veren: Can

## Bağlam
MVP yalnızca Android, ileride iOS ihtimali var. Ekip küçük (tek geliştirici rolü + ajanlar). Ana yük: kimlik doğrulama, medya yükleme/depolama, gerçek zamanlı akış, bildirim. Ajan ofisindeki skill'ler Flutter ve Firebase odaklı.

## Seçenekler
### Mobil
| Seçenek | Artı | Eksi | Maliyet |
|---|---|---|---|
| **Flutter (önerilen)** | Tek kod tabanıyla Android + iOS; ofiste resmi Flutter skill'leri ve `dart mcp-server` hazır; olgun Firebase eklentileri | Native API'lerde (Photo Picker, arka plan yükleme) eklentiye bağımlılık | Ücretsiz |
| Kotlin + Jetpack Compose | En iyi Android entegrasyonu, Google'ın önerdiği yol | iOS gelirse sıfırdan yazılır | Ücretsiz |
| React Native | Geniş ekosistem | Ofisteki skill/MCP desteği yok | Ücretsiz |

### Backend
| Seçenek | Artı | Eksi | Maliyet (DOĞRULA) |
|---|---|---|---|
| **Firebase (önerilen)** | Auth, Firestore (gerçek zamanlı akış), Storage, FCM, Crashlytics, Analytics tek pakette; Flutter desteği birinci sınıf; ofiste skill'ler ve `firebase-tools mcp` hazır | Veri Google sunucularında, yurt dışı aktarım (KVKK) değerlendirilmeli; Firestore sorgu modeli kısıtlı; satıcıya bağımlılık | Spark ücretsiz; Storage ve Functions için Blaze (kullandıkça öde) gerekir |
| Supabase | Postgres (ilişkisel sorgular kolay), açık kaynak, kendin barındırabilme | Push bildirim ve çökme raporu için ek servis (FCM, Sentry) yine gerekir; ofiste skill yok | Ücretsiz katman sınırlı, Pro aylık sabit ücret |

## Karar
Önerilen: **Flutter + Firebase.** Gerekçe: en kısa MVP süresi, ofisin mevcut araçlarıyla tam uyum, iOS'a açık kapı. Medya için Firebase Storage + ileride gerekirse CDN; toplu ZIP indirme için Cloud Functions.

## Sonuçları
- Blaze planı ve bütçe uyarısı gerekir (Can açar, bkz. `HESAPLAR.md` #5).
- KVKK: Firebase ile yurt dışına aktarım var; `guvenlik-kvkk` ajanı aktarım dayanağını ve aydınlatma metnini hazırlayacak.
- Kapı 2'de Can'ın resmî onayıyla "Kabul edildi" olur.
