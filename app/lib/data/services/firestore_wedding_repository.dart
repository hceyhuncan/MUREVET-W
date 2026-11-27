import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/models/join_result.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/wedding.dart';
import '../repositories/wedding_repository.dart';

class FirestoreWeddingRepository implements WeddingRepository {
  FirestoreWeddingRepository({FirebaseFirestore? db, FirebaseFunctions? functions})
      : _db = db ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  @override
  Stream<List<Membership>> watchMemberships(String uid) {
    // users/{uid}/memberships başlık ve rolü tutar; durum için members belgesine bakılır.
    return _db.collection('users/$uid/memberships').snapshots().asyncMap((snap) async {
      final list = <Membership>[];
      for (final d in snap.docs) {
        final member = await _db.doc('weddings/${d.id}/members/$uid').get();
        if (!member.exists) continue;
        list.add(Membership(
          weddingId: d.id,
          title: (d.data()['title'] as String?) ?? '',
          role: Membership.parseRole(member.data()?['role']),
          status: Membership.parseStatus(member.data()?['status']),
        ));
      }
      return list.where((m) => m.status != MemberStatus.removed).toList();
    });
  }

  @override
  Stream<Membership?> watchMembership(String weddingId, String uid) {
    return _db.doc('weddings/$weddingId/members/$uid').snapshots().map((s) {
      if (!s.exists) return null;
      final d = s.data()!;
      return Membership(
        weddingId: weddingId,
        title: '',
        role: Membership.parseRole(d['role']),
        status: Membership.parseStatus(d['status']),
      );
    });
  }

  @override
  Stream<Wedding?> watchWedding(String weddingId) {
    return _db.doc('weddings/$weddingId').snapshots().map((s) {
      if (!s.exists) return null;
      final d = s.data()!;
      final modules = (d['modules'] as Map<String, dynamic>?) ?? const {};
      final k = (modules['katilimci'] as Map<String, dynamic>?) ?? const {};
      final p = (modules['paylasim'] as Map<String, dynamic>?) ?? const {};
      DateTime t(Object? v) => v is Timestamp ? v.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
      return Wedding(
        id: s.id,
        title: (d['title'] as String?) ?? '',
        isActive: d['status'] == 'active',
        katilimci: ModuleWindow(enabled: k['enabled'] == true, start: t(k['start']), end: t(k['end'])),
        paylasimEnabled: p['enabled'] == true,
        paylasimUpload: ModuleWindow(enabled: p['enabled'] == true, start: t(p['uploadStart']), end: t(p['uploadEnd'])),
      );
    });
  }

  @override
  Future<JoinResult> joinWithCode({required String code, required String displayName}) async {
    try {
      final res = await _functions
          .httpsCallable('joinWithCode')
          .call<Map<String, dynamic>>({'code': code, 'displayName': displayName});
      final d = res.data;
      return JoinResult(
        weddingId: d['weddingId'] as String,
        role: Membership.parseRole(d['role']),
        status: Membership.parseStatus(d['status']),
      );
    } on FirebaseFunctionsException catch (e) {
      throw JoinException(switch (e.code) {
        'not-found' => JoinError.notFound,
        'resource-exhausted' => JoinError.tooManyAttempts,
        'failed-precondition' => JoinError.weddingClosed,
        'permission-denied' => JoinError.removed,
        'unauthenticated' => JoinError.notSignedIn,
        _ => JoinError.generic,
      });
    }
  }
}
