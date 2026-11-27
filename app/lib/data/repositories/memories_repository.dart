import '../../domain/models/memories.dart';

/// Modül B: Anı Paylaşımı. Görüntüleme süresiz, yükleme sözleşmedeki pencereyle sınırlı (sunucuda kontrol edilir).
abstract class MemoriesRepository {
  /// Sahip gizlenmiş gönderileri de görür; davetli sadece görünenleri.
  Stream<List<Post>> watchPosts(String weddingId, {required bool includeHidden});

  /// Medyanın indirme bağlantısı (yoksa null).
  Future<String?> mediaUrl(String mediaPath);

  /// Her medya ayrı gönderi olur; birden fazlaysa aynı batchId ile.
  /// [onProgress] 0..1 arası toplam ilerleme.
  Future<void> upload(
    String weddingId,
    String uid,
    List<PickedMedia> media, {
    String? caption,
    void Function(double progress)? onProgress,
  });

  Future<void> setPostHidden(String weddingId, String postId, {required bool hidden});
  Future<void> deletePost(String weddingId, Post post);

  Stream<bool> watchLiked(String weddingId, String postId, String uid);
  Future<void> setLiked(String weddingId, String postId, String uid, {required bool liked});

  Stream<List<PostComment>> watchComments(String weddingId, String postId, {required bool includeHidden});
  Future<void> addComment(String weddingId, String postId, String uid, String text);
  Future<void> setCommentHidden(String weddingId, String postId, String commentId, {required bool hidden});
  Future<void> deleteComment(String weddingId, String postId, String commentId);

  Future<void> report(String weddingId, String uid, ReportTarget target, String targetId, ReportReason reason);

  /// Kullanıcının engellediği kişiler; içerikleri bu kullanıcıya gösterilmez.
  Stream<Set<String>> watchBlocked(String uid);
  Future<void> block(String uid, String otherUid);
}
