import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:murevet/admin/admin_models.dart';
import 'package:murevet/admin/admin_repository.dart';
import 'package:murevet/admin/ui/admin_app.dart';
import 'package:murevet/domain/models/wedding.dart';

class FakeAdmin implements AdminRepository {
  FakeAdmin({this.user});
  AdminUser? user;
  final weddings = <AdminWedding>[];
  final codes = <String, InviteCodes>{};
  final created = <WeddingDraft>[];
  final updated = <(String, WeddingDraft)>[];
  final activeChanges = <(String, bool)>[];
  final granted = <String>[];
  final _tick = StreamController<void>.broadcast();

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    await for (final _ in _tick.stream) {
      yield read();
    }
  }

  void _changed() => _tick.add(null);

  @override
  Stream<AdminUser?> watchUser() => Stream.value(user);
  @override
  Future<void> signIn() async {}
  @override
  Future<void> signOut() async {}
  @override
  Stream<List<AdminWedding>> watchWeddings() => _watch(() => List.of(weddings));
  @override
  Stream<AdminWedding?> watchWedding(String id) => _watch(() => weddings.where((w) => w.id == id).firstOrNull);
  @override
  Stream<InviteCodes> watchCodes(String id) => _watch(() => codes[id] ?? const InviteCodes());
  @override
  Stream<AdminMemberCounts> watchMemberCounts(String id) =>
      Stream.value(const AdminMemberCounts(owners: 2, active: 40, pending: 3));
  @override
  Stream<List<AdminReport>> watchReports(String id) => Stream.value([
    AdminReport(id: 'r1', targetType: 'post', targetId: 'p1', reason: 'nudity', createdAt: DateTime(2026, 6, 1)),
  ]);

  @override
  Future<(String, InviteCodes)> createWedding(WeddingDraft d) async {
    created.add(d);
    final id = 'w${weddings.length + 1}';
    const c = InviteCodes(ownerCode: 'ABCDEFGHJK', guestCode: 'ABCD234');
    codes[id] = c;
    weddings.add(
      AdminWedding(
        id: id,
        title: d.title,
        isActive: true,
        requireApproval: d.requireApproval,
        katilimci: d.katilimci,
        paylasim: d.paylasim,
        contractRef: d.contractRef,
      ),
    );
    _changed();
    return (id, c);
  }

  @override
  Future<void> updateWedding(String id, WeddingDraft d) async => updated.add((id, d));
  @override
  Future<void> setActive(String id, {required bool active}) async {
    activeChanges.add((id, active));
    final i = weddings.indexWhere((w) => w.id == id);
    final w = weddings[i];
    weddings[i] = AdminWedding(
      id: w.id,
      title: w.title,
      isActive: active,
      requireApproval: w.requireApproval,
      katilimci: w.katilimci,
      paylasim: w.paylasim,
    );
    _changed();
  }

  @override
  Future<String> rotateGuestCode(String id) async {
    codes[id] = InviteCodes(ownerCode: codes[id]?.ownerCode, guestCode: 'NEWC234');
    _changed();
    return 'NEWC234';
  }

  @override
  Future<void> grantAdmin(String email) async => granted.add(email);
}

const admin = AdminUser(uid: 'a1', email: 'ekip@lotus.test', isAdmin: true);
final now = DateTime(2026, 5, 1, 12);

Future<void> pump(WidgetTester t, FakeAdmin repo) async {
  t.view.physicalSize = const Size(1400, 1800);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(AdminApp(repo: repo, clock: () => now));
  await t.pumpAndSettle();
}

void main() {
  group('WeddingDraft', () {
    test('paket önerisi: katılımcı paketinde anı modülü kapalı, süreler düğün gününe göre', () {
      final d = WeddingDraft.preset(PackagePreset.katilimci, title: 'A', weddingDay: DateTime(2026, 6, 20), now: now);
      expect(d.katilimci.enabled, isTrue);
      expect(d.paylasim.enabled, isFalse);
      expect(d.katilimci.start, DateTime(2026, 5, 1));
      expect(d.katilimci.end, DateTime(2026, 6, 22));
      expect(d.paylasim.start, DateTime(2026, 6, 20));
      expect(d.validate(), isNull);
    });
    test('geçersiz bilgiler sunucuya gitmeden yakalanır', () {
      final ok = WeddingDraft.preset(PackagePreset.full, title: 'A', weddingDay: DateTime(2026, 6, 20), now: now);
      expect(
        WeddingDraft(title: ' ', requireApproval: true, katilimci: ok.katilimci, paylasim: ok.paylasim).validate(),
        contains('Düğün adı'),
      );
      final bad = ModuleWindow(enabled: true, start: DateTime(2026, 6, 2), end: DateTime(2026, 6, 1));
      expect(
        WeddingDraft(title: 'A', requireApproval: true, katilimci: bad, paylasim: ok.paylasim).validate(),
        contains('Katılımcı'),
      );
      final off = ModuleWindow(enabled: false, start: ok.paylasim.start, end: ok.paylasim.end);
      expect(
        WeddingDraft(
          title: 'A',
          requireApproval: true,
          katilimci: ModuleWindow(enabled: false, start: ok.katilimci.start, end: ok.katilimci.end),
          paylasim: off,
        ).validate(),
        contains('En az bir modül'),
      );
      final json = ok.modulesJson();
      expect((json['paylasim'] as Map)['uploadStart'], endsWith('Z'));
    });
  });

  testWidgets('yönetici olmayan hesap panele giremez', (t) async {
    await pump(
      t,
      FakeAdmin(
        user: const AdminUser(uid: 'x', email: 'misafir@test', isAdmin: false),
      ),
    );
    expect(find.byKey(const Key('no-access')), findsOneWidget);
    expect(find.byKey(const Key('new-wedding')), findsNothing);
  });

  testWidgets('giriş yapmamış kişi giriş ekranını görür', (t) async {
    await pump(t, FakeAdmin());
    expect(find.byKey(const Key('admin-sign-in')), findsOneWidget);
  });

  testWidgets('yönetici paket seçip düğün açar ve kodları görür', (t) async {
    final repo = FakeAdmin(user: admin);
    await pump(t, repo);
    await t.tap(find.byKey(const Key('new-wedding')));
    await t.pumpAndSettle();

    await t.tap(find.byKey(const Key('save')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('form-error')), findsOneWidget, reason: 'ad boşken açılmaz');
    expect(repo.created, isEmpty);

    await t.enterText(find.byKey(const Key('title')), 'Ayşe & Mehmet');
    await t.enterText(find.byKey(const Key('contract')), 'LS-2026-001');
    await t.tap(find.byKey(const Key('package')));
    await t.pumpAndSettle();
    await t.tap(find.text('Katılımcı Organizasyonu paketi').last);
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('save')));
    await t.pumpAndSettle();

    final d = repo.created.single;
    expect(d.title, 'Ayşe & Mehmet');
    expect(d.contractRef, 'LS-2026-001');
    expect(d.katilimci.enabled, isTrue);
    expect(d.paylasim.enabled, isFalse);
    expect(find.text('ABCDEFGHJK'), findsOneWidget);
    expect(find.text('ABCD234'), findsOneWidget);

    await t.tap(find.byKey(const Key('codes-ok')));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('wedding-w1')), findsOneWidget);
  });

  testWidgets('yönetici düğünü kapatır, davetli kodunu yeniler ve şikayetleri görür', (t) async {
    final repo = FakeAdmin(user: admin);
    await repo.createWedding(
      WeddingDraft.preset(PackagePreset.full, title: 'Zeynep & Can', weddingDay: DateTime(2026, 6, 20), now: now),
    );
    await pump(t, repo);
    await t.tap(find.byKey(const Key('wedding-w1')));
    await t.pumpAndSettle();
    expect(find.textContaining('40 aktif, 3 onay bekliyor'), findsOneWidget);
    expect(find.textContaining('Çıplaklık'), findsOneWidget);

    await t.tap(find.byKey(const Key('toggle-active')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('confirm')));
    await t.pumpAndSettle();
    expect(repo.activeChanges, [('w1', false)]);
    expect(find.textContaining('Kapalı'), findsWidgets);

    await t.tap(find.byKey(const Key('rotate-guest')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('confirm')));
    await t.pumpAndSettle();
    expect(find.text('NEWC234'), findsOneWidget);
  });

  testWidgets('yönetici başka bir ekip üyesine yetki verir', (t) async {
    final repo = FakeAdmin(user: admin);
    await pump(t, repo);
    await t.tap(find.byKey(const Key('grant-admin')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('admin-email')), 'yeni@lotus.test');
    await t.tap(find.byKey(const Key('admin-grant')));
    await t.pumpAndSettle();
    expect(repo.granted, ['yeni@lotus.test']);
  });
}
