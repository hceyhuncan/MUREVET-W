import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/membership.dart';
import '../../../l10n/gen/app_localizations.dart';

class MyWeddingsView extends StatelessWidget {
  const MyWeddingsView({super.key, required this.memberships});

  final List<Membership> memberships;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.myWeddings),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final m in memberships)
            Card(
              child: ListTile(
                key: Key('wedding-${m.weddingId}'),
                title: Text(m.title),
                subtitle: Text(m.canEnter ? (m.isOwner ? l.roleOwner : l.roleGuest) : l.pendingTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(m.canEnter ? '/w/${m.weddingId}' : '/w/${m.weddingId}/pending'),
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.push('/join'),
            icon: const Icon(Icons.vpn_key_outlined),
            label: Text(l.joinAnother),
          ),
        ],
      ),
    );
  }
}
