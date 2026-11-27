import 'dart:async';

import 'package:murevet/data/repositories/auth_repository.dart';
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
  Stream<Membership?> watchMembership(String weddingId, String uid) => membershipCtrl.stream;
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
