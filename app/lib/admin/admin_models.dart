import '../domain/models/wedding.dart';

/// Lotus ofisinde imzalanan sözleşme paketleri. Fiyatlar sözleşmede; uygulamada satış yok.
enum PackagePreset {
  full('Tam paket (Katılımcı + Anı)'),
  katilimci('Katılımcı Organizasyonu paketi'),
  paylasim('Anı Paylaşımı paketi'),
  custom('Özel');

  const PackagePreset(this.label);
  final String label;
}

class AdminWedding {
  const AdminWedding({
    required this.id,
    required this.title,
    required this.isActive,
    required this.requireApproval,
    required this.katilimci,
    required this.paylasim,
    this.contractRef,
    this.createdAt,
  });

  final String id;
  final String title;
  final bool isActive;
  final bool requireApproval;
  final ModuleWindow katilimci;

  /// Yükleme penceresi. Görüntüleme süresizdir.
  final ModuleWindow paylasim;
  final String? contractRef;
  final DateTime? createdAt;

  String get packageLabel => switch ((katilimci.enabled, paylasim.enabled)) {
    (true, true) => PackagePreset.full.label,
    (true, false) => PackagePreset.katilimci.label,
    (false, true) => PackagePreset.paylasim.label,
    (false, false) => 'Modül yok',
  };
}

/// Düğün açarken ya da düzenlerken gönderilen bilgiler.
class WeddingDraft {
  const WeddingDraft({
    required this.title,
    required this.requireApproval,
    required this.katilimci,
    required this.paylasim,
    this.contractRef,
  });

  final String title;
  final bool requireApproval;
  final ModuleWindow katilimci;
  final ModuleWindow paylasim;
  final String? contractRef;

  /// Sunucu iki modül için de geçerli bir aralık ister; bitiş başlangıçtan sonra olmalı.
  String? validate() {
    if (title.trim().isEmpty || title.trim().length > 80) return 'Düğün adı 1-80 karakter olmalı.';
    if (contractRef != null && contractRef!.length > 64) return 'Sözleşme no en fazla 64 karakter.';
    if (!katilimci.end.isAfter(katilimci.start)) return 'Katılımcı modülünün bitişi başlangıçtan sonra olmalı.';
    if (!paylasim.end.isAfter(paylasim.start)) return 'Yükleme bitişi başlangıçtan sonra olmalı.';
    if (!katilimci.enabled && !paylasim.enabled) return 'En az bir modül açık olmalı.';
    return null;
  }

  Map<String, Object?> modulesJson() => {
    'katilimci': {
      'enabled': katilimci.enabled,
      'start': katilimci.start.toUtc().toIso8601String(),
      'end': katilimci.end.toUtc().toIso8601String(),
    },
    'paylasim': {
      'enabled': paylasim.enabled,
      'uploadStart': paylasim.start.toUtc().toIso8601String(),
      'uploadEnd': paylasim.end.toUtc().toIso8601String(),
    },
  };

  /// Paket ve düğün gününe göre önerilen süreler (VARSAYIM, sözleşmeye göre değiştirilebilir):
  /// Katılımcı: bugünden düğünün ertesi gününe kadar. Anı yükleme: düğün günü 00:00'dan 2 gün sonrasına kadar.
  static WeddingDraft preset(PackagePreset p, {required String title, required DateTime weddingDay, DateTime? now}) {
    final day = DateTime(weddingDay.year, weddingDay.month, weddingDay.day);
    final today = now ?? DateTime.now();
    final kStart = DateTime(today.year, today.month, today.day);
    return WeddingDraft(
      title: title,
      requireApproval: true,
      katilimci: ModuleWindow(
        enabled: p == PackagePreset.full || p == PackagePreset.katilimci || p == PackagePreset.custom,
        start: kStart.isBefore(day) ? kStart : day,
        end: day.add(const Duration(days: 2)),
      ),
      paylasim: ModuleWindow(
        enabled: p == PackagePreset.full || p == PackagePreset.paylasim || p == PackagePreset.custom,
        start: day,
        end: day.add(const Duration(days: 3)),
      ),
    );
  }
}

class InviteCodes {
  const InviteCodes({this.ownerCode, this.guestCode});
  final String? ownerCode;
  final String? guestCode;
}

class AdminMemberCounts {
  const AdminMemberCounts({required this.owners, required this.active, required this.pending});
  final int owners;
  final int active;
  final int pending;
}

class AdminReport {
  const AdminReport({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.createdAt,
  });
  final String id;
  final String targetType;
  final String targetId;
  final String reason;
  final DateTime createdAt;
}

class AdminUser {
  const AdminUser({required this.uid, this.email, required this.isAdmin});
  final String uid;
  final String? email;
  final bool isAdmin;
}
