import '../../domain/models/join_result.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/wedding.dart';

abstract class WeddingRepository {
  /// Giriş yapmış kullanıcının üyelikleri.
  Stream<List<Membership>> watchMemberships(String uid);

  /// Kullanıcının belirli bir düğündeki güncel üyelik durumu (onay bekleme ekranı için).
  Stream<Membership?> watchMembership(String weddingId, String uid);

  Stream<Wedding?> watchWedding(String weddingId);

  /// Kodla katılım. Hata durumunda [JoinException] fırlatır.
  Future<JoinResult> joinWithCode({required String code, required String displayName});
}
