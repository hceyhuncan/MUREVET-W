import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:murevet/domain/models/membership.dart';
import 'package:murevet/domain/models/program.dart';
import 'package:murevet/l10n/gen/app_localizations.dart';
import 'package:murevet/ui/features/program/program_view.dart';
import 'package:murevet/ui/features/wedding_home/wedding_home_view.dart';

import 'fakes.dart';

Widget host(Widget child) => MaterialApp(
  locale: const Locale('tr'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(body: child),
);

Membership member(MemberRole role) =>
    Membership(weddingId: 'w1', title: 'Ayşe & Mehmet', role: role, status: MemberStatus.active);

void main() {
  testWidgets('davetli LCV verir; sahip araçlarını görmez', (t) async {
    final p = FakeProgram();
    await t.pumpWidget(host(ProgramView(weddingId: 'w1', uid: 'g1', isOwner: false, editable: true, repo: p)));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('add-event')), findsNothing);
    expect(find.byKey(const Key('open-guests')), findsNothing);

    await t.tap(find.text('Katılıyorum'));
    await t.pump();
    await t.tap(find.byKey(const Key('rsvp-plus')));
    await t.pump();
    await t.ensureVisible(find.byKey(const Key('rsvp-save')));
    await t.tap(find.byKey(const Key('rsvp-save')));
    await t.pumpAndSettle();
    expect(p.rsvps['g1']?.answer, RsvpAnswer.yes);
    expect(p.rsvps['g1']?.headcount, 2);
  });

  testWidgets('modül süresi dolunca davetli LCV kartını görmez', (t) async {
    await t.pumpWidget(
      host(ProgramView(weddingId: 'w1', uid: 'g1', isOwner: false, editable: false, repo: FakeProgram())),
    );
    await t.pumpAndSettle();
    expect(find.byKey(const Key('rsvp-save')), findsNothing);
  });

  testWidgets('sahip duyuru ve etkinlik ekler', (t) async {
    final p = FakeProgram();
    await t.pumpWidget(host(ProgramView(weddingId: 'w1', uid: 'o1', isOwner: true, editable: true, repo: p)));
    await t.pumpAndSettle();

    await t.tap(find.byKey(const Key('add-announcement')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('announcement-text')), 'Servis 18:00de kalkıyor');
    await t.tap(find.byKey(const Key('announcement-send')));
    await t.pumpAndSettle();
    expect(find.text('Servis 18:00de kalkıyor'), findsOneWidget);

    await t.ensureVisible(find.byKey(const Key('add-event')));
    await t.tap(find.byKey(const Key('add-event')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('event-name')), 'Nikah');
    await t.enterText(find.byKey(const Key('event-venue')), 'Lotus Bahçe');
    await t.enterText(find.byKey(const Key('event-map')), 'http://kotu.link');
    await t.tap(find.byKey(const Key('event-save')));
    await t.pumpAndSettle();
    expect(p.events, isEmpty, reason: 'https olmayan harita bağlantısı reddedilmeli');
    await t.enterText(find.byKey(const Key('event-map')), '');
    await t.tap(find.byKey(const Key('event-save')));
    await t.pumpAndSettle();
    expect(p.events.single.name, 'Nikah');
    expect(find.text('Nikah'), findsOneWidget);
  });

  testWidgets('sahip bekleyen davetliyi onaylar, kodu ve LCV özetini görür', (t) async {
    final p = FakeProgram()
      ..guests.addAll(const [
        Guest(uid: 'g1', displayName: 'Ali', isPending: true, isOwner: false),
        Guest(
          uid: 'g2',
          displayName: 'Zeynep',
          isPending: false,
          isOwner: false,
          rsvp: Rsvp(answer: RsvpAnswer.yes, headcount: 3),
        ),
      ]);
    await t.pumpWidget(host(ProgramView(weddingId: 'w1', uid: 'o1', isOwner: true, editable: true, repo: p)));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('open-guests')));
    await t.pumpAndSettle();
    expect(find.text('ABCD234'), findsOneWidget);
    expect(find.textContaining('3 kişi geliyor'), findsOneWidget);
    await t.tap(find.byKey(const Key('approve-g1')));
    await t.pumpAndSettle();
    expect(p.statusChanges, [('g1', true)]);
  });

  testWidgets('düğün ekranı sadece açık modüllerin sekmelerini gösterir', (t) async {
    await t.pumpWidget(
      host(
        WeddingHomeView(
          wedding: Stream.value(testWedding(paylasim: false)),
          membership: Stream.value(member(MemberRole.guest)),
          uid: 'g1',
          program: FakeProgram(),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(ProgramView), findsOneWidget);
  });
}
