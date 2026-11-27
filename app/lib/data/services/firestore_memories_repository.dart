import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/models/memories.dart';
import '../repositories/memories_repository.dart';

class FirestoreMemoriesRepository implements MemoriesRepository {
  FirestoreMemoriesRepository({FirebaseFirestore? db, FirebaseStorage? storage})
    : _db = db ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  DateTime _t(Object? v) => v is Timestamp ? v.toDate() : DateTime.now();

  Post _post(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    return Post(
      id: d.id,
      authorUid: m['authorUid'] as String,
      authorName: m['authorName'] as String,
      mediaPath: m['mediaPath'] as String,
      mediaType: m['mediaType'] == 'video' ? MediaType.video : MediaType.image,
      createdAt: _t(m['createdAt']),
      caption: m['caption'] as String?,
      isHidden: m['status'] == 'hidden',
      likeCount: (m['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (m['commentCount'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Stream<List<Post>> watchPosts(String w, {required bool includeHidden}) {
    Query<Map<String, dynamic>> q = _db.collection('weddings/$w/posts');
    // Kurallar davetlinin sadece görünen gönderileri sorgulamasına izin verir.
    if (!includeHidden) q = q.where('status', isEqualTo: 'visible');
    return q
        .orderBy('createdAt', descending: true)
        .limit(300)
        .snapshots()
        .map((s) => [for (final d in s.docs) _post(d)]);
  }

  @override
  Future<String?> mediaUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }

  Future<String> _myName(String w, String uid) async {
    final m = await _db.doc('weddings/$w/members/$uid').get();
    final name = (m.data()?['displayName'] as String?)?.trim();
    return (name == null || name.isEmpty) ? 'Davetli' : name;
  }

  static String _fileName(PickedMedia m) {
    final dot = m.name.lastIndexOf('.');
    final ext = dot >= 0 ? m.name.substring(dot + 1).toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '') : '';
    return ext.isEmpty ? 'media' : 'media.${ext.length > 5 ? ext.substring(0, 5) : ext}';
  }

  @override
  Future<void> upload(
    String w,
    String uid,
    List<PickedMedia> media, {
    String? caption,
    void Function(double progress)? onProgress,
  }) async {
    final name = await _myName(w, uid);
    final col = _db.collection('weddings/$w/posts');
    final batchId = media.length > 1 ? col.doc().id : null;
    final total = media.fold<int>(0, (s, m) => s + m.size);
    var done = 0;
    for (final m in media) {
      final type = m.type;
      if (type == null || !m.isAllowed) continue;
      final ref = col.doc();
      final path = 'weddings/$w/posts/${ref.id}/${_fileName(m)}';
      final file = _storage.ref(path);
      final meta = SettableMetadata(contentType: m.mimeType, customMetadata: {'uploaderUid': uid});
      final task = m.path != null ? file.putFile(File(m.path!), meta) : file.putData(m.bytes!, meta);
      task.snapshotEvents.listen((s) => onProgress?.call(total == 0 ? 1 : (done + s.bytesTransferred) / total));
      await task;
      done += m.size;
      try {
        await ref.set({
          'authorUid': uid,
          'authorName': name,
          'mediaPath': path,
          'mediaType': type.name,
          if (caption != null && caption.isNotEmpty) 'caption': caption,
          'batchId': ?batchId,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'visible',
          'likeCount': 0,
          'commentCount': 0,
        });
      } catch (_) {
        await file.delete().catchError((_) {});
        rethrow;
      }
    }
  }

  @override
  Future<void> setPostHidden(String w, String p, {required bool hidden}) =>
      _db.doc('weddings/$w/posts/$p').update({'status': hidden ? 'hidden' : 'visible'});

  /// Belge silinince medya dosyasını sunucu (onPostDelete) temizler.
  @override
  Future<void> deletePost(String w, Post post) => _db.doc('weddings/$w/posts/${post.id}').delete();

  @override
  Stream<bool> watchLiked(String w, String p, String uid) =>
      _db.doc('weddings/$w/posts/$p/likes/$uid').snapshots().map((s) => s.exists);

  @override
  Future<void> setLiked(String w, String p, String uid, {required bool liked}) {
    final ref = _db.doc('weddings/$w/posts/$p/likes/$uid');
    return liked ? ref.set({'uid': uid, 'createdAt': FieldValue.serverTimestamp()}) : ref.delete();
  }

  @override
  Stream<List<PostComment>> watchComments(String w, String p, {required bool includeHidden}) {
    Query<Map<String, dynamic>> q = _db.collection('weddings/$w/posts/$p/comments');
    if (!includeHidden) q = q.where('status', isEqualTo: 'visible');
    return q
        .orderBy('createdAt')
        .limit(200)
        .snapshots()
        .map(
          (s) => [
            for (final d in s.docs)
              PostComment(
                id: d.id,
                authorUid: d['authorUid'] as String,
                authorName: d['authorName'] as String,
                text: d['text'] as String,
                createdAt: _t(d.data()['createdAt']),
                isHidden: d['status'] == 'hidden',
              ),
          ],
        );
  }

  @override
  Future<void> addComment(String w, String p, String uid, String text) async {
    final name = await _myName(w, uid);
    await _db.collection('weddings/$w/posts/$p/comments').add({
      'authorUid': uid,
      'authorName': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'visible',
    });
  }

  @override
  Future<void> setCommentHidden(String w, String p, String c, {required bool hidden}) =>
      _db.doc('weddings/$w/posts/$p/comments/$c').update({'status': hidden ? 'hidden' : 'visible'});

  @override
  Future<void> deleteComment(String w, String p, String c) => _db.doc('weddings/$w/posts/$p/comments/$c').delete();

  @override
  Future<void> report(String w, String uid, ReportTarget target, String targetId, ReportReason reason) =>
      _db.collection('weddings/$w/reports').add({
        'reporterUid': uid,
        'targetType': target.name,
        'targetId': targetId,
        'reason': reason.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

  @override
  Stream<Set<String>> watchBlocked(String uid) =>
      _db.collection('users/$uid/blocks').snapshots().map((s) => {for (final d in s.docs) d.id});

  @override
  Future<void> block(String uid, String other) =>
      _db.doc('users/$uid/blocks/$other').set({'createdAt': FieldValue.serverTimestamp()});
}
