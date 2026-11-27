import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/models/program.dart';
import '../repositories/program_repository.dart';

class FirestoreProgramRepository implements ProgramRepository {
  FirestoreProgramRepository({FirebaseFirestore? db, FirebaseFunctions? functions})
    : _db = db ?? FirebaseFirestore.instance,
      _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  DateTime _t(Object? v) => v is Timestamp ? v.toDate() : DateTime.now();

  @override
  Stream<List<WeddingEvent>> watchEvents(String w) => _db
      .collection('weddings/$w/events')
      .orderBy('startAt')
      .snapshots()
      .map(
        (s) => [
          for (final d in s.docs)
            WeddingEvent(
              id: d.id,
              name: d['name'] as String,
              startAt: _t(d['startAt']),
              venueName: d['venueName'] as String,
              address: d.data()['address'] as String?,
              mapUrl: d.data()['mapUrl'] as String?,
            ),
        ],
      );

  @override
  Future<void> saveEvent(String w, WeddingEvent e, {bool isNew = false}) {
    final col = _db.collection('weddings/$w/events');
    final ref = isNew ? col.doc() : col.doc(e.id);
    return ref.set({
      'name': e.name,
      'startAt': Timestamp.fromDate(e.startAt),
      'venueName': e.venueName,
      if (e.address != null && e.address!.isNotEmpty) 'address': e.address,
      if (e.mapUrl != null && e.mapUrl!.isNotEmpty) 'mapUrl': e.mapUrl,
    });
  }

  @override
  Future<void> deleteEvent(String w, String id) => _db.doc('weddings/$w/events/$id').delete();

  @override
  Stream<List<Announcement>> watchAnnouncements(String w) => _db
      .collection('weddings/$w/announcements')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map(
        (s) => [
          for (final d in s.docs)
            Announcement(id: d.id, text: d['text'] as String, createdAt: _t(d.data()['createdAt'])),
        ],
      );

  @override
  Future<void> postAnnouncement(String w, String authorUid, String text) => _db
      .collection('weddings/$w/announcements')
      .add({'text': text, 'createdAt': FieldValue.serverTimestamp(), 'authorUid': authorUid});

  @override
  Future<void> deleteAnnouncement(String w, String id) => _db.doc('weddings/$w/announcements/$id').delete();

  Rsvp? _rsvp(Map<String, dynamic>? d) {
    final a = Rsvp.parse(d?['answer']);
    if (a == null) return null;
    return Rsvp(answer: a, headcount: (d!['headcount'] as num).toInt(), note: d['note'] as String?);
  }

  @override
  Stream<Rsvp?> watchMyRsvp(String w, String uid) =>
      _db.doc('weddings/$w/rsvps/$uid').snapshots().map((s) => _rsvp(s.data()));

  @override
  Future<void> saveRsvp(String w, String uid, Rsvp r) => _db.doc('weddings/$w/rsvps/$uid').set({
    'answer': r.answer.name,
    'headcount': r.headcount,
    if (r.note != null && r.note!.trim().isNotEmpty) 'note': r.note!.trim(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  @override
  Stream<List<Guest>> watchGuests(String w) {
    final members = _db.collection('weddings/$w/members').where('status', whereIn: ['active', 'pending']).snapshots();
    final rsvps = _db.collection('weddings/$w/rsvps').snapshots();
    late StreamController<List<Guest>> ctrl;
    QuerySnapshot<Map<String, dynamic>>? m, r;
    StreamSubscription? s1, s2;
    void emit() {
      if (m == null || r == null) return;
      final byUid = {for (final d in r!.docs) d.id: _rsvp(d.data())};
      final list = [
        for (final d in m!.docs)
          Guest(
            uid: d.id,
            displayName: d['displayName'] as String,
            isPending: d['status'] == 'pending',
            isOwner: d['role'] == 'owner',
            rsvp: byUid[d.id],
          ),
      ]..sort((a, b) => a.displayName.compareTo(b.displayName));
      ctrl.add(list);
    }

    ctrl = StreamController<List<Guest>>(
      onListen: () {
        s1 = members.listen((v) {
          m = v;
          emit();
        }, onError: ctrl.addError);
        s2 = rsvps.listen((v) {
          r = v;
          emit();
        }, onError: ctrl.addError);
      },
      onCancel: () async {
        await s1?.cancel();
        await s2?.cancel();
      },
    );
    return ctrl.stream;
  }

  @override
  Future<void> setGuestStatus(String w, String uid, {required bool active}) =>
      _db.doc('weddings/$w/members/$uid').update({'status': active ? 'active' : 'removed'});

  @override
  Stream<String?> watchGuestCode(String w) =>
      _db.doc('weddings/$w/private/invite').snapshots().map((s) => s.data()?['guestCode'] as String?);

  @override
  Future<String> rotateGuestCode(String w) async {
    final res = await _functions.httpsCallable('rotateGuestCode').call<Map<String, dynamic>>({'weddingId': w});
    return res.data['guestCode'] as String;
  }
}
