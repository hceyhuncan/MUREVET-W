/// Bir modülün açık olduğu zaman aralığı. Yetki sunucuda kontrol edilir;
/// bu sınıf sadece arayüzde doğru durumu göstermek içindir.
class ModuleWindow {
  const ModuleWindow({required this.enabled, required this.start, required this.end});

  final bool enabled;
  final DateTime start;
  final DateTime end;

  bool isOpenAt(DateTime now) => enabled && !now.isBefore(start) && !now.isAfter(end);
}

class Wedding {
  const Wedding({
    required this.id,
    required this.title,
    required this.isActive,
    required this.katilimci,
    required this.paylasimEnabled,
    required this.paylasimUpload,
  });

  final String id;
  final String title;
  final bool isActive;

  /// A. Katılımcı Organizasyonu
  final ModuleWindow katilimci;

  /// B. Anı Paylaşımı: görüntüleme süresiz (düğün sonrası bulut erişimi), yükleme pencereli.
  final bool paylasimEnabled;
  final ModuleWindow paylasimUpload;
}
