import 'package:material_ui/material_ui.dart';

import '../../../domain/models/wedding.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Düğün ana ekranı: sadece sözleşmede açılan modüllerin sekmeleri görünür.
/// Modül içerikleri sonraki PR'larda (A: Program/LCV/duyuru, B: Anılar) eklenecek.
class WeddingHomeView extends StatelessWidget {
  const WeddingHomeView({super.key, required this.wedding, DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final Stream<Wedding?> wedding;
  final DateTime Function() _clock;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return StreamBuilder<Wedding?>(
      stream: wedding,
      builder: (context, snap) {
        final w = snap.data;
        if (w == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final tabs = <(String, Widget)>[
          if (w.katilimci.enabled)
            (l.tabProgram, _ModulePlaceholder(open: w.katilimci.isOpenAt(_clock()))),
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
