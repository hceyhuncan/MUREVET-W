# Murevet Ajan Ofisi

Fikirden Google Play yayınına kadar gereken her şey bu klasörde. Repo açıldığında bu klasörün tamamı repo köküne kopyalanır ve Claude Code hepsini otomatik tanır.

## İçindekiler
| Yer | Ne var |
|---|---|
| `CLAUDE.md` | Ofisin kuralları (her oturum ilk bunu okur) |
| `SUREC.md` | Ekip, akış, faz kapıları |
| `HESAPLAR.md` | Açılması gereken hesaplar ve **senin yapacakların** |
| `.claude/agents/` | 9 alt ajan, her biri kendi skill'lerine bağlı |
| `.claude/skills/` | 31 skill: 28 resmi (Flutter, Firebase, Android/Play, Anthropic) + 3 Türkiye/Play'e özel |
| `.mcp.json` | Dart ve Firebase MCP sunucuları (taslak, kurulumda etkinleşir) |
| `sablonlar/` | Ürün tanımı, pazar raporu, ekran, API, karar, test, sürüm, mağaza listesi |
| `kontrol-listeleri/faz-kapilari.md` | 3 onay kapısının maddeleri |
| `docs/` | Ajan çıktılarının gideceği boş klasörler |

## Ajan → skill eşleşmesi
| Ajan | Skill'ler |
|---|---|
| ürün stratejisti | doc-coauthoring |
| pazar araştırmacı | doc-coauthoring |
| UX/UI tasarımcı | flutter-build-responsive-layout, canvas-design |
| mobil geliştirici | 10 Flutter/Dart skill'i, Firebase Auth/Firestore/Crashlytics/Analytics/Remote Config, anr-audit-and-fix |
| backend geliştirici | firebase-basics, auth, firestore, firestore-rules-creation, hosting, remote-config, ugc-moderasyon, kvkk-gizlilik |
| QA/test | dart unit + mock, flutter widget + entegrasyon testi, anr-audit-and-fix, ugc-moderasyon |
| güvenlik ve KVKK | kvkk-gizlilik, ugc-moderasyon, firebase-security-rules-auditor, android-permissions-security, play-policy-insights |
| Play yayın | play-yayin-hazirligi, play-policy-insights, canvas-design |
| pazarlama | canvas-design, doc-coauthoring |

## Bilinçli olarak eklemediklerim
- Kotlin/Jetpack Compose skill'leri: Flutter seçimi değişirse eklenir (android/skills reposunda hazır).
- Supabase skill'leri: backend Firebase yerine Supabase olursa eklenir.
- skill-creator: zaten yerleşik olarak var.
- Üçüncü taraf topluluk skill'leri: resmi kaynaklar yeterli olduğu için güvenlik gereği eklenmedi. `mobile-mcp` (emülatörü ajanla sürmek için) ileride değerlendirilebilir.

## Bilinen boşluklar
- Hukuki metinlerin son hali bir hukukçudan geçmeli.
- Play kuralları (`DOĞRULA:` etiketli değerler) her yayından önce resmi kaynaktan kontrol edilecek.
