/// Kod biçimi sunucudaki functions/src/codes.ts ile aynı olmalı.
const codeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
const guestCodeLength = 7;
const ownerCodeLength = 10;

/// Boşluk ve tireyi atar, büyük harfe çevirir. Geçersizse null döner.
String? normalizeCode(String input) {
  final c = input.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  if (c.length != guestCodeLength && c.length != ownerCodeLength) return null;
  for (final ch in c.split('')) {
    if (!codeAlphabet.contains(ch)) return null;
  }
  return c;
}
