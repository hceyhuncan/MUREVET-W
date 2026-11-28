import 'admin_models.dart';

/// Lotus yönetim paneli. Tüm yazmalar sunucu fonksiyonlarıyla yapılır (admin özel alanı gerekli).
abstract class AdminRepository {
  Stream<AdminUser?> watchUser();
  Future<void> signIn();
  Future<void> signOut();

  Stream<List<AdminWedding>> watchWeddings();
  Stream<AdminWedding?> watchWedding(String id);
  Stream<InviteCodes> watchCodes(String id);
  Stream<AdminMemberCounts> watchMemberCounts(String id);
  Stream<List<AdminReport>> watchReports(String id);

  /// Yeni düğün ve kodlarını oluşturur; dönen kodlar sahibe ofiste teslim edilir.
  Future<(String weddingId, InviteCodes codes)> createWedding(WeddingDraft draft);
  Future<void> updateWedding(String id, WeddingDraft draft);
  Future<void> setActive(String id, {required bool active});
  Future<String> rotateGuestCode(String id);
  Future<void> grantAdmin(String email);
}
