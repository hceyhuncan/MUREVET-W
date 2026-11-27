import { Timestamp } from 'firebase-admin/firestore';
import { HttpsError } from 'firebase-functions/v2/https';

export function reqString(v: unknown, name: string, min = 1, max = 100): string {
  if (typeof v !== 'string') throw new HttpsError('invalid-argument', `${name} gerekli`);
  const s = v.trim();
  if (s.length < min || s.length > max) throw new HttpsError('invalid-argument', `${name} uzunluğu geçersiz`);
  return s;
}

export function reqTimestamp(v: unknown, name: string): Timestamp {
  if (typeof v !== 'string' || Number.isNaN(Date.parse(v))) {
    throw new HttpsError('invalid-argument', `${name} ISO tarih olmalı`);
  }
  return Timestamp.fromDate(new Date(v));
}

export interface ModulesInput {
  katilimci?: { enabled?: unknown; start?: unknown; end?: unknown };
  paylasim?: { enabled?: unknown; uploadStart?: unknown; uploadEnd?: unknown };
}

export function parseModules(input: unknown) {
  const m = (input ?? {}) as ModulesInput;
  const k = m.katilimci ?? {};
  const p = m.paylasim ?? {};
  const katilimci = {
    enabled: k.enabled === true,
    start: reqTimestamp(k.start, 'katilimci.start'),
    end: reqTimestamp(k.end, 'katilimci.end'),
  };
  const paylasim = {
    enabled: p.enabled === true,
    uploadStart: reqTimestamp(p.uploadStart, 'paylasim.uploadStart'),
    uploadEnd: reqTimestamp(p.uploadEnd, 'paylasim.uploadEnd'),
  };
  if (katilimci.end.toMillis() <= katilimci.start.toMillis()) {
    throw new HttpsError('invalid-argument', 'katilimci bitişi başlangıçtan sonra olmalı');
  }
  if (paylasim.uploadEnd.toMillis() <= paylasim.uploadStart.toMillis()) {
    throw new HttpsError('invalid-argument', 'paylasim bitişi başlangıçtan sonra olmalı');
  }
  return { katilimci, paylasim };
}
