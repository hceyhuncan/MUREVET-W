# Karar 002: Google Play geliştirici hesabı türü
Tarih: 2026-11-27 · Durum: Önerildi · Karar veren: Can

## Bağlam
Play'de yayın için geliştirici hesabı gerekir. Hesap türü, mağazada görünen adı, üretime çıkış süresini ve ödeme/fatura tarafını etkiler. Kimlik doğrulaması günler sürebildiği için karar geliştirme başlamadan verilmeli.

## Seçenekler
| Seçenek | Artı | Eksi | Maliyet (DOĞRULA) |
|---|---|---|---|
| **Bireysel hesap** | Hemen açılır, şirket gerekmez | Mağazada kişisel adın görünür; yeni bireysel hesaplar üretimden önce kapalı test yapmak zorunda (DOĞRULA: en az 12 testçi, 14 gün kesintisiz) | Tek seferlik ~25 USD |
| **Kurumsal hesap** | Şirket adı görünür, güven verir; kapalı test şartından muaf; ileride ödeme/fatura için uygun | Şirket ve D-U-N-S numarası gerekir (D-U-N-S başvurusu günler-haftalar sürebilir) | ~25 USD + şirket kuruluş/muhasebe maliyeti |

## Karar
Önerilen: **Şirketin varsa kurumsal, yoksa bireysel.** Sırf Play için şirket kurmak MVP'yi geciktirir; kapalı test zaten kalite için faydalı ve ilk düğünler (ör. tanıdık çiftler ve davetlileri) 12 testçiyi kolayca karşılar. Premium satışa (Play Faturalandırma) geçerken vergi/fatura nedeniyle şirket yeniden değerlendirilir; bireysel hesaptan kurumsala taşıma süreci ayrıca doğrulanmalı (DOĞRULA).

## Sonuçları
- Bireysel seçilirse: yayın takvimine 14+ günlük kapalı test ve testçi listesi (HESAPLAR.md #8) eklenir.
- Kurumsal seçilirse: D-U-N-S başvurusu hemen başlatılmalı.
