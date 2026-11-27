import { randomInt } from 'crypto';

// Karışan karakterler yok: 0/O, 1/I/L
export const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
export const GUEST_CODE_LENGTH = 7;
export const OWNER_CODE_LENGTH = 10;

export function generateCode(length: number): string {
  let out = '';
  for (let i = 0; i < length; i++) out += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  return out;
}

/** Kullanıcının yazdığı kodu normalleştirir: boşluk/tire atılır, büyük harfe çevrilir. */
export function normalizeCode(input: unknown): string | null {
  if (typeof input !== 'string') return null;
  const c = input.replace(/[\s-]/g, '').toUpperCase();
  if (c.length < GUEST_CODE_LENGTH || c.length > OWNER_CODE_LENGTH) return null;
  for (const ch of c) if (!CODE_ALPHABET.includes(ch)) return null;
  return c;
}
