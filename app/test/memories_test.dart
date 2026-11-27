import 'dart:typed_data';

import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:murevet/domain/models/memories.dart';
import 'package:murevet/l10n/gen/app_localizations.dart';
import 'package:murevet/ui/features/memories/memories_view.dart';

import 'fakes.dart';

Widget host(Widget child) => MaterialApp(
  locale: const Locale('tr'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: child,
);

Post post(String id, String author, {bool hidden = false}) => Post(
  id: id,
  authorUid: author,
  authorName: author == 'g2' ? 'Zeynep' : 'Ali',
  mediaPath: 'weddings/w1/posts/$id/media.jpg',
  mediaType: MediaType.image,
  createdAt: DateTime(2026, 6, 1, 20),
  isHidden: hidden,
);

PickedMedia media(String name, String mime, int size) =>
    PickedMedia(name: name, mimeType: mime, size: size, bytes: Uint8List(0));

MemoriesView view(FakeMemories repo, FakePicker picker, {bool owner = false, bool canUpload = true}) =>
    MemoriesView(weddingId: 'w1', uid: 'g1', isOwner: owner, canUpload: canUpload, repo: repo, picker: picker);

void main() {
  test('boyut ve tür sınırları sunucu kurallarıyla aynı', () {
    expect(media('a.jpg', 'image/jpeg', 15 * 1024 * 1024).isAllowed, isTrue);
    expect(media('a.jpg', 'image/jpeg', 15 * 1024 * 1024 + 1).isAllowed, isFalse);
    expect(media('a.mp4', 'video/mp4', 150 * 1024 * 1024).isAllowed, isTrue);
    expect(media('a.pdf', 'application/pdf', 10).isAllowed, isFalse);
  });

  testWidgets('davetli fotoğraf seçer, açıklama yazar ve paylaşır; büyük dosya atlanır', (t) async {
    final repo = FakeMemories();
    final picker = FakePicker()
      ..next = [media('a.jpg', 'image/jpeg', 1000), media('b.mp4', 'video/mp4', 200 * 1024 * 1024)];
    await t.pumpWidget(host(view(repo, picker)));
    await t.pumpAndSettle();
    expect(find.textContaining('Henüz anı'), findsOneWidget);

    await t.tap(find.byKey(const Key('add-memory')));
    await t.pumpAndSettle();
    expect(find.text('1 dosya seçildi'), findsOneWidget);
    await t.enterText(find.byKey(const Key('caption')), 'Gelin girişi');
    await t.tap(find.byKey(const Key('upload-share')));
    await t.pumpAndSettle();
    expect(repo.uploads.single.$1.single.name, 'a.jpg');
    expect(repo.uploads.single.$2, 'Gelin girişi');
    expect(find.byKey(const Key('post-p1')), findsOneWidget);
  });

  testWidgets('yükleme süresi bitince paylaşım düğmesi yok ama anılar görünür', (t) async {
    final repo = FakeMemories()..posts.add(post('p1', 'g2'));
    await t.pumpWidget(host(view(repo, FakePicker(), canUpload: false)));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('add-memory')), findsNothing);
    expect(find.byKey(const Key('post-p1')), findsOneWidget);
    expect(find.textContaining('Yükleme süresi doldu'), findsOneWidget);
  });

  testWidgets('davetli beğenir, yorum yazar, şikayet eder ve engeller', (t) async {
    final repo = FakeMemories()..posts.add(post('p1', 'g2'));
    await t.pumpWidget(host(view(repo, FakePicker())));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('post-p1')));
    await t.pumpAndSettle();

    await t.tap(find.byKey(const Key('like')));
    await t.pumpAndSettle();
    expect(repo.likes, {'p1/g1'});

    await t.enterText(find.byKey(const Key('comment-text')), 'Çok güzel!');
    await t.tap(find.byKey(const Key('comment-send')));
    await t.pumpAndSettle();
    expect(find.text('Çok güzel!'), findsOneWidget);

    await t.tap(find.byKey(const Key('post-menu')));
    await t.pumpAndSettle();
    expect(find.text('Gizle'), findsNothing, reason: 'davetli gizleyemez');
    await t.tap(find.text('Şikayet et'));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('reason-nudity')));
    await t.pumpAndSettle();
    expect(repo.reports.single, (ReportTarget.post, 'p1', ReportReason.nudity));

    await t.tap(find.byKey(const Key('post-menu')));
    await t.pumpAndSettle();
    await t.tap(find.text('Kişiyi engelle'));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('confirm')));
    await t.pumpAndSettle();
    expect(repo.blocked, {'g2'});
    expect(find.byKey(const Key('post-p1')), findsNothing, reason: 'engellenen kişinin anıları görünmez');
  });

  testWidgets('sahip uygunsuz anıyı gizler; davetli gizliyi görmez', (t) async {
    final repo = FakeMemories()..posts.add(post('p1', 'g2'));
    await t.pumpWidget(host(view(repo, FakePicker(), owner: true)));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('post-p1')));
    await t.pumpAndSettle();
    await t.tap(find.byKey(const Key('post-menu')));
    await t.pumpAndSettle();
    await t.tap(find.text('Gizle'));
    await t.pumpAndSettle();
    expect(repo.posts.single.isHidden, isTrue);
    expect(find.textContaining('Gizli'), findsOneWidget);

    await t.pumpWidget(host(view(repo, FakePicker())));
    await t.pumpAndSettle();
    expect(find.byKey(const Key('post-p1')), findsNothing);
  });
}
