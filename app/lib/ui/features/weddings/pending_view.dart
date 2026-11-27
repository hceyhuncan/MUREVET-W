import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/membership.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Katılım onayı bekleyen davetli. Onay gelince otomatik olarak düğüne geçer.
class PendingView extends StatelessWidget {
  const PendingView({super.key, required this.weddingId, required this.membership});

  final String weddingId;
  final Stream<Membership?> membership;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return StreamBuilder<Membership?>(
      stream: membership,
      builder: (context, snap) {
        if (snap.data?.status == MemberStatus.active) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/w/$weddingId');
          });
        }
        final removed = snap.data?.status == MemberStatus.removed;
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_top_outlined, size: 56),
                const SizedBox(height: 16),
                Text(removed ? l.errorRemoved : l.pendingTitle,
                    style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                if (!removed) Text(l.pendingBody, textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}
