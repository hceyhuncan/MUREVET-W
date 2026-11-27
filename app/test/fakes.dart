import 'dart:async';

import 'package:murevet/data/repositories/auth_repository.dart';
import 'package:murevet/data/repositories/program_repository.dart';
import 'package:murevet/domain/models/program.dart';
import 'package:murevet/data/repositories/wedding_repository.dart';
import 'package:murevet/domain/models/join_result.dart';
import 'package:murevet/domain/models/membership.dart';
import 'package:murevet/domain/models/wedding.dart';

class FakeAuth implements AuthRepository {
  // ignore: prefer_initializing_formals
  FakeAuth({AppUser? user}) : _user = user;
  AppUser? _user;
  final _ctrl = StreamController<AppUser?>.broadcast();
  int signInCalls = 0;
  bool deleted = false;

  @override
  AppUser? get currentUser => _user;
  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _ctrl.stream;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    signInCalls++;
    _user = const AppUser(uid: 'u1', displayName: 'Ayşe Yılmaz');
    _ctrl.add(_user);
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _ctrl.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    deleted = true;
    await signOut();
  }
}

class FakeWeddings implements WeddingRepository {
  List<Membership> memberships = [];
  Wedding? wedding;
  JoinResult? joinResult;
  JoinError? joinError;
  String? lastCode;
  String? lastName;
  final membershipCtrl = StreamController<Membership?>.broadcast();

  @override
  Stream<List<Membership>> watchMemberships(String uid) => Stream.value(memberships);
  @override
  Stream<Membership?> watchMembership(String weddingId, String uid) async* {
    final m = memberships.where((m) => m.weddingId == weddingId).firstOrNull;
    if (m != null) yield m;
    yield* membershipCtrl.stream;
  }
  @override
  Stream<Wedding?> watchWedding(String weddingId) => Stream.value(wedding);
  @override
  Future<JoinResult> joinWithCode({required String code, required String displayName}) async {
    lastCode = code;
    lastName = displayName;
    if (joinError != null) throw JoinException(joinError!);
    return joinResult!;
  }
}

Wedding testWedding({bool katilimci = true, bool paylasim = true, bool katilimciOpen = true}) {
  final now = DateTime.now();
  return Wedding(
    id: 'w1',
    title: 'Ayşe & Mehmet',
    isActive: true,
    katilimci: ModuleWindow(
      enabled: katilimci,
      start: now.subtract(const Duration(hours: 1)),
      end: katilimciOpen ? now.add(const Duration(hours: 1)) : now.subtract(const Duration(minutes: 1)),
    ),
    paylasimEnabled: paylasim,
    paylasimUpload: ModuleWindow(enabled: paylasim, start: now, end: now.add(const Duration(hours: 1))),
  );
}

class FakeProgram implements ProgramRepository {
  final events = <WeddingEvent>[];
  final announcements = <Announcement>[];
  final rsvps = <String, Rsvp>{};
  final guests = <Guest>[];
  String guestCode = 'ABCD234';
  final statusChanges = <(String, bool)>[];

  final _tick = StreamController<void>.broadcast();
  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    await for (final _ in _tick.stream) {
      yield read();
    }
  }

  void _changed() => _tick.add(null);

  @override
  Stream<List<WeddingEvent>> watchEvents(String w) => _watch(() => List.of(events));
  @override
  Future<void> saveEvent(String w, WeddingEvent e, {bool isNew = false}) async {
    events.removeWhere((x) => x.id == e.id);
    events.add(
      isNew
          ? WeddingEvent(
              id: 'e${events.length + 1}',
              name: e.name,
              startAt: e.startAt,
              venueName: e.venueName,
              address: e.address,
              mapUrl: e.mapUrl,
            )
          : e,
    );
    _changed();
  }

  @override
  Future<void> deleteEvent(String w, String id) async {
    events.removeWhere((x) => x.id == id);
    _changed();
  }

  @override
  Stream<List<Announcement>> watchAnnouncements(String w) => _watch(() => List.of(announcements));
  @override
  Future<void> postAnnouncement(String w, String authorUid, String text) async {
    announcements.insert(0, Announcement(id: 'a${announcements.length + 1}', text: text, createdAt: DateTime.now()));
    _changed();
  }

  @override
  Future<void> deleteAnnouncement(String w, String id) async {
    announcements.removeWhere((x) => x.id == id);
    _changed();
  }

  @override
  Stream<Rsvp?> watchMyRsvp(String w, String uid) => _watch(() => rsvps[uid]);
  @override
  Future<void> saveRsvp(String w, String uid, Rsvp rsvp) async {
    rsvps[uid] = rsvp;
    _changed();
  }

  @override
  Stream<List<Guest>> watchGuests(String w) => _watch(() => List.of(guests));
  @override
  Future<void> setGuestStatus(String w, String uid, {required bool active}) async {
    statusChanges.add((uid, active));
    final i = guests.indexWhere((g) => g.uid == uid);
    if (i >= 0) {
      final g = guests[i];
      if (active) {
        guests[i] = Guest(uid: g.uid, displayName: g.displayName, isPending: false, isOwner: false, rsvp: g.rsvp);
      } else {
        guests.removeAt(i);
      }
    }
    _changed();
  }

  @override
  Stream<String?> watchGuestCode(String w) => _watch(() => guestCode);
  @override
  Future<String> rotateGuestCode(String w) async {
    guestCode = 'NEWC234';
    _changed();
    return guestCode;
  }
}
