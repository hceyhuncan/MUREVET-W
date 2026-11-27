import 'dart:typed_data';

enum MediaType { image, video }

/// Bir gönderi = bir medya (fotoğraf veya video).
class Post {
  const Post({
    required this.id,
    required this.authorUid,
    required this.authorName,
    required this.mediaPath,
    required this.mediaType,
    required this.createdAt,
    this.caption,
    this.isHidden = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  final String id;
  final String authorUid;
  final String authorName;
  final String mediaPath;
  final MediaType mediaType;
  final DateTime createdAt;
  final String? caption;
  final bool isHidden;
  final int likeCount;
  final int commentCount;
}

class PostComment {
  const PostComment({
    required this.id,
    required this.authorUid,
    required this.authorName,
    required this.text,
    required this.createdAt,
    this.isHidden = false,
  });

  final String id;
  final String authorUid;
  final String authorName;
  final String text;
  final DateTime createdAt;
  final bool isHidden;
}

/// Kurallardaki `reason` değerleriyle aynı.
enum ReportReason { inappropriate, harassment, nudity, copyright, other }

enum ReportTarget { post, comment, member }

/// Kullanıcının seçtiği, henüz yüklenmemiş medya.
/// Büyük videolar belleğe alınmadan [path] üzerinden yüklenir; [bytes] testler ve web içindir.
class PickedMedia {
  const PickedMedia({required this.name, required this.mimeType, required this.size, this.path, this.bytes});

  final String name;
  final String mimeType;
  final int size;
  final String? path;
  final Uint8List? bytes;

  MediaType? get type => mimeType.startsWith('image/')
      ? MediaType.image
      : mimeType.startsWith('video/')
      ? MediaType.video
      : null;

  /// Sunucu kurallarıyla aynı sınırlar: görsel 15 MB, video 150 MB.
  static const maxImageBytes = 15 * 1024 * 1024;
  static const maxVideoBytes = 150 * 1024 * 1024;

  bool get isAllowed => switch (type) {
    MediaType.image => size <= maxImageBytes,
    MediaType.video => size <= maxVideoBytes,
    null => false,
  };
}
