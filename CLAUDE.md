# Murevet: ajan ofisi kuralları

Murevet, düğünler için özel bir sosyal paylaşım uygulamasıdır (Android, Google Play). Kullanıcı (Can) Türkçe yazar; tüm dokümanlar ve yanıtlar Türkçe.

## Ekip
`.claude/agents/` altındaki 9 alt ajan, süreç: `SUREC.md`. Koordinatör ana oturumdur; işi aşamalara böler, uygun ajana verir, çıktıları birbirine aktarır.

## Klasörler
- `docs/01-urun` … `docs/09-pazarlama`: ajan çıktıları
- `docs/kararlar/`: karar kayıtları (`sablonlar/karar-kaydi.md`)
- `sablonlar/`: tüm çıktılar için başlangıç şablonları
- `kontrol-listeleri/faz-kapilari.md`: aşama geçiş kontrolleri
- `.claude/skills/`: skill'ler (kaynaklar `KAYNAKLAR.md`)

## Kurallar
1. Varsayımlar `VARSAYIM:`, tahminler `TAHMİN:`, sık değişen kurallar `DOĞRULA:` ile işaretlenir.
2. Kod değişikliği dal + PR ile yapılır; ana dala doğrudan yazılmaz.
3. Geri alınamayan adımlar (Play Console gönderimi, üretim ortamı, dışarıya mesaj, ödeme) yalnızca Can'ın açık onayıyla.
4. Gizli bilgi repoya yazılmaz.
5. Faz kapısı geçmeden bir sonraki faza başlanmaz; kapı listesi doldurulup Can'a sunulur.
6. Hukuki metinler taslaktır.

## Teknoloji (VARSAYIM, Kapı 2'de onaylanacak)
Flutter + Firebase (Auth, Firestore, Storage, FCM, Crashlytics, Analytics, Hosting). MCP: `dart mcp-server`, `firebase-tools mcp` (`.mcp.json`).
