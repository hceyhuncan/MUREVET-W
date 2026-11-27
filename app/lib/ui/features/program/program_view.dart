import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/program_repository.dart';
import '../../../domain/models/program.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'event_editor.dart';
import 'guests_view.dart';
import 'rsvp_card.dart';

/// Modül A: Katılımcı Organizasyonu sekmesi.
/// [editable] modül süresinin açık olup olmadığını gösterir; asıl kontrol sunucudadır.
class ProgramView extends StatelessWidget {
  const ProgramView({
    super.key,
    required this.weddingId,
    required this.uid,
    required this.isOwner,
    required this.editable,
    required this.repo,
  });

  final String weddingId;
  final String uid;
  final bool isOwner;
  final bool editable;
  final ProgramRepository repo;

  Future<void> _run(BuildContext context, Future<void> Function() f) async {
    try {
      await f();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saveFailed)));
      }
    }
  }

  Future<void> _writeAnnouncement(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.writeAnnouncement),
        content: TextField(
          key: const Key('announcement-text'),
          controller: ctrl,
          maxLength: 1000,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(hintText: l.announcementHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l.cancel)),
          FilledButton(
            key: const Key('announcement-send'),
            onPressed: () => Navigator.pop(c, ctrl.text.trim()),
            child: Text(l.send),
          ),
        ],
      ),
    );
    if (text == null || text.isEmpty || !context.mounted) return;
    await _run(context, () => repo.postAnnouncement(weddingId, uid, text));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dateFmt = DateFormat('d MMMM y, EEEE HH:mm', 'tr');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (isOwner) ...[
          OutlinedButton.icon(
            key: const Key('open-guests'),
            icon: const Icon(Icons.people_outline),
            label: Text(l.guests),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => GuestsView(weddingId: weddingId, repo: repo),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (!isOwner && editable) ...[RsvpCard(weddingId: weddingId, uid: uid, repo: repo), const SizedBox(height: 16)],
        if (!editable) ...[Text(l.moduleClosedEdit, style: text.bodySmall), const SizedBox(height: 8)],
        Row(
          children: [
            Expanded(child: Text(l.announcements, style: text.titleLarge)),
            if (isOwner && editable)
              IconButton(
                key: const Key('add-announcement'),
                tooltip: l.writeAnnouncement,
                icon: const Icon(Icons.campaign_outlined),
                onPressed: () => _writeAnnouncement(context),
              ),
          ],
        ),
        StreamBuilder<List<Announcement>>(
          stream: repo.watchAnnouncements(weddingId),
          builder: (context, snap) {
            final list = snap.data ?? const [];
            if (list.isEmpty) return Padding(padding: const EdgeInsets.all(8), child: Text(l.noAnnouncements));
            return Column(
              children: [
                for (final a in list)
                  Card(
                    child: ListTile(
                      title: Text(a.text),
                      subtitle: Text(DateFormat('d MMM HH:mm', 'tr').format(a.createdAt)),
                      trailing: isOwner
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: l.delete,
                              onPressed: () => _run(context, () => repo.deleteAnnouncement(weddingId, a.id)),
                            )
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: Text(l.program, style: text.titleLarge)),
            if (isOwner && editable)
              IconButton(
                key: const Key('add-event'),
                tooltip: l.addEvent,
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final e = await showEventEditor(context);
                  if (e != null && context.mounted) {
                    await _run(context, () => repo.saveEvent(weddingId, e, isNew: true));
                  }
                },
              ),
          ],
        ),
        StreamBuilder<List<WeddingEvent>>(
          stream: repo.watchEvents(weddingId),
          builder: (context, snap) {
            final list = snap.data ?? const [];
            if (list.isEmpty) return Padding(padding: const EdgeInsets.all(8), child: Text(l.noEvents));
            return Column(
              children: [
                for (final e in list)
                  Card(
                    child: ListTile(
                      key: Key('event-${e.id}'),
                      leading: const Icon(Icons.event_outlined),
                      title: Text(e.name),
                      subtitle: Text(
                        [dateFmt.format(e.startAt), e.venueName, if (e.address != null) e.address!].join('\n'),
                      ),
                      isThreeLine: true,
                      onTap: isOwner && editable
                          ? () async {
                              final edited = await showEventEditor(context, initial: e);
                              if (edited != null && context.mounted) {
                                await _run(context, () => repo.saveEvent(weddingId, edited));
                              }
                            }
                          : null,
                      trailing: isOwner && editable
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: l.delete,
                              onPressed: () => _run(context, () => repo.deleteEvent(weddingId, e.id)),
                            )
                          : (e.mapUrl != null ? Icon(Icons.map_outlined, semanticLabel: l.openMap) : null),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
