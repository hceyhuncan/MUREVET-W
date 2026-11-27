import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/program.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Etkinlik ekleme/düzenleme. Doğrulama kurallarla aynı: ad ≤60, mekân ≤100, harita https.
Future<WeddingEvent?> showEventEditor(BuildContext context, {WeddingEvent? initial}) {
  return Navigator.of(context)
      .push<WeddingEvent>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => _EventEditor(initial: initial)));
}

class _EventEditor extends StatefulWidget {
  const _EventEditor({this.initial});
  final WeddingEvent? initial;

  @override
  State<_EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<_EventEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _venue = TextEditingController(text: widget.initial?.venueName);
  late final _address = TextEditingController(text: widget.initial?.address);
  late final _map = TextEditingController(text: widget.initial?.mapUrl);
  late DateTime _start = widget.initial?.startAt ?? DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    for (final c in [_name, _venue, _address, _map]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (d != null) setState(() => _start = DateTime(d.year, d.month, d.day, _start.hour, _start.minute));
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_start));
    if (t != null) setState(() => _start = DateTime(_start.year, _start.month, _start.day, t.hour, t.minute));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String? required(String? v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null;
    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? l.addEvent : l.editEvent)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('event-name'),
              controller: _name,
              maxLength: 60,
              decoration: InputDecoration(labelText: l.eventName, hintText: l.eventNameHint),
              validator: required,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(DateFormat('d MMM y', 'tr').format(_start)),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: Text(DateFormat('HH:mm').format(_start)),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('event-venue'),
              controller: _venue,
              maxLength: 100,
              decoration: InputDecoration(labelText: l.venueName),
              validator: required,
            ),
            TextFormField(
              controller: _address,
              maxLength: 200,
              decoration: InputDecoration(labelText: l.address),
            ),
            TextFormField(
              key: const Key('event-map'),
              controller: _map,
              maxLength: 500,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(labelText: l.mapUrl),
              validator: (v) => (v == null || v.isEmpty || v.startsWith('https://')) ? null : l.mapUrlInvalid,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('event-save'),
              onPressed: () {
                if (!_form.currentState!.validate()) return;
                Navigator.pop(
                  context,
                  WeddingEvent(
                    id: widget.initial?.id ?? '',
                    name: _name.text.trim(),
                    startAt: _start,
                    venueName: _venue.text.trim(),
                    address: _address.text.trim().isEmpty ? null : _address.text.trim(),
                    mapUrl: _map.text.trim().isEmpty ? null : _map.text.trim(),
                  ),
                );
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}
