import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/models/wedding.dart';
import 'admin_models.dart';
import 'admin_repository.dart';

class FirebaseAdminRepository implements AdminRepository {
  FirebaseAdminRepository({FirebaseAuth? auth, FirebaseFirestore? db, FirebaseFunctions? functions})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = db ?? FirebaseFirestore.instance,
      _fn = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirebaseFunctions _fn;

  static DateTime _t(Object? v) => v is Timestamp ? v.toDate() : DateTime.fromMillisecondsSinceEpoch(0);

  static AdminWedding _wedding(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    final mods = (m['modules'] as Map?) ?? const {};
    final k = (mods['katilimci'] as Map?) ?? const {};
    final p = (mods['paylasim'] as Map?) ?? const {};
    return AdminWedding(
      id: d.id,
      title: (m['title'] as String?) ?? '',
      isActive: m['status'] == 'active',
      requireApproval: m['requireApproval'] == true,
      contractRef: m['contractRef'] as String?,
      createdAt: m['createdAt'] is Timestamp ? _t(m['createdAt']) : null,
      katilimci: ModuleWindow(enabled: k['enabled'] == true, start: _t(k['start']), end: _t(k['end'])),
      paylasim: ModuleWindow(enabled: p['enabled'] == true, start: _t(p['uploadStart']), end: _t(p['uploadEnd'])),
    );
  }

  @override
  Stream<AdminUser?> watchUser() => _auth.idTokenChanges().asyncMap((u) async {
    if (u == null) return null;
    final token = await u.getIdTokenResult();
    return AdminUser(uid: u.uid, email: u.email, isAdmin: token.claims?['admin'] == true);
  });

  /// Web'de Google açılır penceresi.
  @override
  Future<void> signIn() async {
    await _auth.signInWithPopup(GoogleAuthProvider());
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Stream<List<AdminWedding>> watchWeddings() => _db
      .collection('weddings')
      .orderBy('createdAt', descending: true)
      .limit(500)
      .snapshots()
      .map((s) => [for (final d in s.docs) _wedding(d)]);

  @override
  Stream<AdminWedding?> watchWedding(String id) =>
      _db.doc('weddings/$id').snapshots().map((d) => d.exists ? _wedding(d) : null);

  @override
  Stream<InviteCodes> watchCodes(String id) => _db
      .doc('weddings/$id/private/invite')
      .snapshots()
      .map(
        (d) => InviteCodes(ownerCode: d.data()?['ownerCode'] as String?, guestCode: d.data()?['guestCode'] as String?),
      );

  @override
  Stream<AdminMemberCounts> watchMemberCounts(String id) => _db.collection('weddings/$id/members').snapshots().map((s) {
    var owners = 0, active = 0, pending = 0;
    for (final d in s.docs) {
      final m = d.data();
      if (m['role'] == 'owner') owners++;
      if (m['status'] == 'active') active++;
      if (m['status'] == 'pending') pending++;
    }
    return AdminMemberCounts(owners: owners, active: active, pending: pending);
  });

  @override
  Stream<List<AdminReport>> watchReports(String id) => _db
      .collection('weddings/$id/reports')
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (s) => [
          for (final d in s.docs)
            AdminReport(
              id: d.id,
              targetType: d['targetType'] as String,
              targetId: d['targetId'] as String,
              reason: d['reason'] as String,
              createdAt: _t(d.data()['createdAt']),
            ),
        ],
      );

  @override
  Future<(String, InviteCodes)> createWedding(WeddingDraft draft) async {
    final res = await _fn.httpsCallable('adminCreateWedding').call<Map<String, dynamic>>({
      'title': draft.title.trim(),
      'requireApproval': draft.requireApproval,
      'modules': draft.modulesJson(),
      if (draft.contractRef != null && draft.contractRef!.trim().isNotEmpty) 'contractRef': draft.contractRef!.trim(),
    });
    final d = res.data;
    return (
      d['weddingId'] as String,
      InviteCodes(ownerCode: d['ownerCode'] as String?, guestCode: d['guestCode'] as String?),
    );
  }

  @override
  Future<void> updateWedding(String id, WeddingDraft draft) => _fn.httpsCallable('adminUpdateWedding').call<void>({
    'weddingId': id,
    'title': draft.title.trim(),
    'requireApproval': draft.requireApproval,
    'modules': draft.modulesJson(),
  });

  @override
  Future<void> setActive(String id, {required bool active}) =>
      _fn.httpsCallable('adminUpdateWedding').call<void>({'weddingId': id, 'status': active ? 'active' : 'closed'});

  @override
  Future<String> rotateGuestCode(String id) async {
    final res = await _fn.httpsCallable('rotateGuestCode').call<Map<String, dynamic>>({'weddingId': id});
    return res.data['guestCode'] as String;
  }

  @override
  Future<void> grantAdmin(String email) => _fn.httpsCallable('adminGrant').call<void>({'email': email.trim()});
}
