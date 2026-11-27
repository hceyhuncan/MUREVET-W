import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/program_repository.dart';
import '../../../domain/models/program.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Sahip ekranı: davetli kodu, onay bekleyenler, LCV özeti ve davetli listesi.
class GuestsView extends StatelessWidget {
  const GuestsView({super.key, required this.weddingId, required this.repo});

  final String weddingId;
  final ProgramRepository repo;

  Future<bool> _confirm(BuildContext context, String title, String body) async {
    final l = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
              FilledButton(key: const Key('confirm'), onPressed: () => Navigator.pop(c, true), child: Text(title)),
            ],
          ),
        ) ==
        true;
  }

  String _rsvpLabel(AppLocalizations l, Rsvp? r) => switch (r?.answer) {
    RsvpAnswer.yes => '${l.rsvpYes} (${r!.headcount})',
    RsvpAnswer.no => l.rsvpNo,
    RsvpAnswer.maybe => l.rsvpMaybe,
    null => '—',
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.guests)),
      body: StreamBuilder<List<Guest>>(
        stream: repo.watchGuests(weddingId),
        builder: (context, snap) {
          final guests = snap.data ?? const <Guest>[];
          final pending = guests.where((g) => g.isPending).toList();
          final active = guests.where((g) => !g.isPending).toList();
          final s = RsvpSummary.of(active.where((g) => !g.isOwner).toList());
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<String?>(
                    stream: repo.watchGuestCode(weddingId),
                    builder: (context, codeSnap) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.guestCode, style: text.titleMedium),
                        const SizedBox(height: 8),
                        SelectableText(
                          codeSnap.data ?? '…',
                          key: const Key('guest-code'),
                          style: text.headlineMedium?.copyWith(letterSpacing: 6),
                        ),
                        const SizedBox(height: 8),
                        Text(l.shareCodeHint, style: text.bodySmall),
                        TextButton.icon(
                          key: const Key('rotate-code'),
                          icon: const Icon(Icons.refresh),
                          label: Text(l.rotateCode),
                          onPressed: () async {
                            if (await _confirm(context, l.rotateCode, l.rotateCodeConfirm)) {
                              await repo.rotateGuestCode(weddingId);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.rsvpSummary(s.yesPeople, s.noCount, s.maybeCount, s.noAnswer), key: const Key('rsvp-summary')),
              if (pending.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('${l.pendingApprovals} (${pending.length})', style: text.titleMedium),
                for (final g in pending)
                  ListTile(
                    key: Key('pending-${g.uid}'),
                    title: Text(g.displayName),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: l.reject,
                          icon: const Icon(Icons.close),
                          onPressed: () => repo.setGuestStatus(weddingId, g.uid, active: false),
                        ),
                        IconButton(
                          key: Key('approve-${g.uid}'),
                          tooltip: l.approve,
                          icon: const Icon(Icons.check),
                          onPressed: () => repo.setGuestStatus(weddingId, g.uid, active: true),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Text('${l.guests} (${active.length})', style: text.titleMedium),
              for (final g in active)
                ListTile(
                  title: Text(g.displayName),
                  subtitle: Text(g.isOwner ? l.roleOwner : _rsvpLabel(l, g.rsvp)),
                  trailing: g.isOwner
                      ? null
                      : IconButton(
                          tooltip: l.removeGuest,
                          icon: const Icon(Icons.person_remove_outlined),
                          onPressed: () async {
                            if (await _confirm(context, l.removeGuest, l.removeGuestConfirm(g.displayName))) {
                              await repo.setGuestStatus(weddingId, g.uid, active: false);
                            }
                          },
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}
