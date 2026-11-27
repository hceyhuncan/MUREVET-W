import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/program_repository.dart';
import '../../../domain/models/program.dart';
import '../../../l10n/gen/app_localizations.dart';

class RsvpCard extends StatefulWidget {
  const RsvpCard({super.key, required this.weddingId, required this.uid, required this.repo});

  final String weddingId;
  final String uid;
  final ProgramRepository repo;

  @override
  State<RsvpCard> createState() => _RsvpCardState();
}

class _RsvpCardState extends State<RsvpCard> {
  RsvpAnswer? _answer;
  int _headcount = 1;
  bool _loaded = false;

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.repo.saveRsvp(widget.weddingId, widget.uid, Rsvp(answer: _answer!, headcount: _headcount));
      messenger.showSnackBar(SnackBar(content: Text(l.rsvpSaved)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.saveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return StreamBuilder<Rsvp?>(
      stream: widget.repo.watchMyRsvp(widget.weddingId, widget.uid),
      builder: (context, snap) {
        if (!_loaded && snap.hasData) {
          _answer = snap.data!.answer;
          _headcount = snap.data!.headcount;
          _loaded = true;
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.rsvpTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<RsvpAnswer>(
                  key: const Key('rsvp-answer'),
                  emptySelectionAllowed: true,
                  segments: [
                    ButtonSegment(value: RsvpAnswer.yes, label: Text(l.rsvpYes)),
                    ButtonSegment(value: RsvpAnswer.maybe, label: Text(l.rsvpMaybe)),
                    ButtonSegment(value: RsvpAnswer.no, label: Text(l.rsvpNo)),
                  ],
                  selected: {?_answer},
                  onSelectionChanged: (s) => setState(() => _answer = s.isEmpty ? null : s.first),
                ),
                if (_answer == RsvpAnswer.yes) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text(l.rsvpHeadcount)),
                      IconButton(
                        onPressed: _headcount > 1 ? () => setState(() => _headcount--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_headcount', key: const Key('rsvp-headcount')),
                      IconButton(
                        key: const Key('rsvp-plus'),
                        onPressed: _headcount < 10 ? () => setState(() => _headcount++) : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('rsvp-save'),
                  onPressed: _answer == null ? null : _save,
                  child: Text(l.save),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
