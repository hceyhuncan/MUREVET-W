import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:murevet/data/repositories/auth_repository.dart';
import 'package:murevet/domain/models/join_result.dart';
import 'package:murevet/domain/models/membership.dart';
import 'package:murevet/ui/app.dart';

import 'fakes.dart';

Future<void> pumpApp(WidgetTester t, FakeAuth auth, FakeWeddings w) async {
  await t.pumpWidget(MurevetApp(auth: auth, weddings: w, program: FakeProgram()));
  await t.pumpAndSettle();
}

void main() {
  testWidgets('kodu olmayan kullanıcı sadece ön modülü görür', (t) async {
    await pumpApp(t, FakeAuth(), FakeWeddings());
    expect(find.text('Sadece davetlilere özel'), findsOneWidget);
    expect(find.text('Kodum var'), findsOneWidget);
    expect(find.text('Düğünlerim'), findsNothing);
  });

  testWidgets('giriş yapmış ama üyeliği olmayan kullanıcı da ön modülde kalır', (t) async {
    await pumpApp(t, FakeAuth(user: const AppUser(uid: 'u1')), FakeWeddings());
    expect(find.text('Kodum var'), findsOneWidget);
  });

  testWidgets('geçersiz biçimdeki kod sunucuya gitmeden reddedilir', (t) async {
    final w = FakeWeddings();
    await pumpApp(t, FakeAuth(user: const AppUser(uid: 'u1', displayName: 'Ali')), w);
    await t.tap(find.byKey(const Key('gate-have-code')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('join-code')), 'ABC');
    await t.tap(find.byKey(const Key('join-submit')));
    await t.pumpAndSettle();
    expect(find.textContaining('7 veya 10 karakter'), findsOneWidget);
    expect(w.lastCode, isNull);
  });

  testWidgets('giriş yapmamış kullanıcı kodu yazar, Google ile girer ve onay beklemeye düşer', (t) async {
    final auth = FakeAuth();
    final w = FakeWeddings()
      ..joinResult = const JoinResult(weddingId: 'w1', role: MemberRole.guest, status: MemberStatus.pending);
    await pumpApp(t, auth, w);
    await t.tap(find.byKey(const Key('gate-have-code')));
    await t.pumpAndSettle();
    expect(find.text('Google ile giriş yap'), findsOneWidget);
    await t.enterText(find.byKey(const Key('join-code')), 'abc d234');
    await t.tap(find.byKey(const Key('join-submit')));
    await t.pumpAndSettle();
    expect(auth.signInCalls, 1);
    expect(w.lastCode, 'ABCD234');
    expect(w.lastName, 'Ayşe Yılmaz');
    expect(find.text('Onay bekleniyor'), findsOneWidget);
  });

  testWidgets('sunucu kodu reddederse anlaşılır hata gösterilir', (t) async {
    final w = FakeWeddings()..joinError = JoinError.notFound;
    await pumpApp(t, FakeAuth(user: const AppUser(uid: 'u1', displayName: 'Ali')), w);
    await t.tap(find.byKey(const Key('gate-have-code')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('join-code')), 'ABCD234');
    await t.tap(find.byKey(const Key('join-submit')));
    await t.pumpAndSettle();
    expect(find.text('Bu kod geçersiz veya artık kullanılmıyor.'), findsOneWidget);
  });

  testWidgets('üye kullanıcı düğünlerini görür ve sadece açık modüllerin sekmeleri çıkar', (t) async {
    final w = FakeWeddings()
      ..memberships = [
        const Membership(weddingId: 'w1', title: 'Ayşe & Mehmet', role: MemberRole.guest, status: MemberStatus.active),
      ]
      ..wedding = testWedding(katilimci: false, paylasim: true);
    await pumpApp(t, FakeAuth(user: const AppUser(uid: 'u1')), w);
    expect(find.text('Düğünlerim'), findsOneWidget);
    await t.tap(find.byKey(const Key('wedding-w1')));
    await t.pumpAndSettle();
    expect(find.text('Ayşe & Mehmet'), findsOneWidget);
    expect(find.text('Program'), findsNothing);
  });

  testWidgets('hesap silme onay ister ve sonra ön modüle döner', (t) async {
    final auth = FakeAuth(user: const AppUser(uid: 'u1'));
    final w = FakeWeddings()
      ..memberships = [
        const Membership(weddingId: 'w1', title: 'A', role: MemberRole.guest, status: MemberStatus.active),
      ];
    await pumpApp(t, auth, w);
    await t.tap(find.byTooltip('Ayarlar'));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('delete-account')));
    await t.pumpAndSettle();
    expect(find.textContaining('kalıcı olarak silinecek'), findsOneWidget);
    await t.tap(find.byKey(const Key('confirm-delete')));
    await t.pumpAndSettle();
    expect(auth.deleted, isTrue);
    expect(find.text('Kodum var'), findsOneWidget);
  });
}
