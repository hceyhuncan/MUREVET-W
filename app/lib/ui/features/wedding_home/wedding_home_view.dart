import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/program_repository.dart';
import '../../../domain/models/membership.dart';
import '../../../domain/models/wedding.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../program/program_view.dart';

/// Düğün ana ekranı: sadece sözleşmede açılan modüllerin sekmeleri görünür.
/// B (Anılar) içeriği sonraki PR'da eklenecek.
class WeddingHomeView extends StatelessWidget {
  const WeddingHomeView({
    super.key,
    required this.wedding,
    required this.membership,
    required this.uid,
    required this.program,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Stream<Wedding?> wedding;
  final Stream<Membership?> membership;
  final String uid;
  final ProgramRepository program;
  final DateTime Function() _clock;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return StreamBuilder<Membership?>(
      stream: membership,
      builder: (context, mSnap) => StreamBuilder<Wedding?>(
        stream: wedding,
        builder: (context, snap) {
          final w = snap.data;
          final m = mSnap.data;
          if (w == null || m == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (!m.canEnter) {
            return Scaffold(
              appBar: AppBar(title: Text(w.title)),
              body: Center(child: Text(l.moduleClosed)),
            );
          }
          final tabs = <(String, Widget)>[
            if (w.katilimci.enabled)
              (
                l.tabProgram,
                ProgramView(
                  weddingId: w.id,
                  uid: uid,
                  isOwner: m.isOwner,
                  editable: w.isActive && w.katilimci.isOpenAt(_clock()),
                  repo: program,
                ),
              ),
            if (w.paylasimEnabled) (l.tabMemories, const _ModulePlaceholder(open: true)),
          ];
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text(w.title),
                bottom: tabs.length > 1 ? TabBar(tabs: [for (final t in tabs) Tab(text: t.$1)]) : null,
              ),
              body: tabs.isEmpty
                  ? Center(child: Text(l.moduleClosed))
                  : tabs.length == 1
                  ? tabs.first.$2
                  : TabBarView(children: [for (final t in tabs) t.$2]),
            ),
          );
        },
      ),
    );
  }
}

class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({required this.open});
  final bool open;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(child: Text(open ? l.comingSoon : l.moduleClosed));
  }
}
