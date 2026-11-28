import 'package:material_ui/material_ui.dart';

import '../../domain/models/wedding.dart';
import '../admin_models.dart';
import '../admin_repository.dart';
import 'codes_card.dart';
import 'common.dart';

/// Yeni düğün açma veya mevcut düğünün modül sürelerini düzenleme.
class WeddingFormPage extends StatefulWidget {
  const WeddingFormPage({super.key, required this.repo, this.initial, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AdminRepository repo;
  final AdminWedding? initial;
  final DateTime Function() _clock;

  @override
  State<WeddingFormPage> createState() => _WeddingFormPageState();
}

class _WeddingFormPageState extends State<WeddingFormPage> {
  late final _title = TextEditingController(text: widget.initial?.title ?? '');
  late final _contract = TextEditingController(text: widget.initial?.contractRef ?? '');
  PackagePreset _package = PackagePreset.full;
  late DateTime _day = widget.initial?.paylasim.start ?? widget._clock().add(const Duration(days: 30));
  late bool _approval = widget.initial?.requireApproval ?? true;
  late ModuleWindow _k;
  late ModuleWindow _p;
  bool _saving = false;
  String? _error;

  bool get _isNew => widget.initial == null;

  @override
  void initState() {
    super.initState();
    if (_isNew) {
      _applyPreset();
    } else {
      _k = widget.initial!.katilimci;
      _p = widget.initial!.paylasim;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _contract.dispose();
    super.dispose();
  }

  void _applyPreset() {
    final d = WeddingDraft.preset(_package, title: _title.text, weddingDay: _day, now: widget._clock());
    _k = d.katilimci;
    _p = d.paylasim;
  }

  WeddingDraft get _draft => WeddingDraft(
    title: _title.text,
    requireApproval: _approval,
    katilimci: _k,
    paylasim: _p,
    contractRef: _contract.text.trim().isEmpty ? null : _contract.text.trim(),
  );

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (d == null || !mounted) return null;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> _save() async {
    final draft = _draft;
    final err = draft.validate();
    setState(() => _error = err);
    if (err != null) return;
    setState(() => _saving = true);
    try {
      if (_isNew) {
        final (_, codes) = await widget.repo.createWedding(draft);
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (c) => AlertDialog(
            title: Text('${draft.title.trim()} açıldı'),
            content: SizedBox(width: 520, child: CodesView(codes: codes)),
            actions: [
              FilledButton(key: const Key('codes-ok'), onPressed: () => Navigator.pop(c), child: const Text('Tamam')),
            ],
          ),
        );
      } else {
        await widget.repo.updateWedding(widget.initial!.id, draft);
        if (mounted) toast(context, 'Kaydedildi.');
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _window(String title, String hint, ModuleWindow w, String key, ValueChanged<ModuleWindow> onChanged) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              key: Key('$key-enabled'),
              contentPadding: EdgeInsets.zero,
              title: Text(title),
              subtitle: Text(hint),
              value: w.enabled,
              onChanged: (v) => onChanged(ModuleWindow(enabled: v, start: w.start, end: w.end)),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  key: Key('$key-start'),
                  icon: const Icon(Icons.play_arrow_outlined),
                  label: Text('Başlangıç: ${dateTimeFmt.format(w.start)}'),
                  onPressed: () async {
                    final v = await _pickDateTime(w.start);
                    if (v != null) onChanged(ModuleWindow(enabled: w.enabled, start: v, end: w.end));
                  },
                ),
                OutlinedButton.icon(
                  key: Key('$key-end'),
                  icon: const Icon(Icons.stop_outlined),
                  label: Text('Bitiş: ${dateTimeFmt.format(w.end)}'),
                  onPressed: () async {
                    final v = await _pickDateTime(w.end);
                    if (v != null) onChanged(ModuleWindow(enabled: w.enabled, start: w.start, end: v));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? 'Yeni düğün' : 'Düğünü düzenle')),
      body: Narrow(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              key: const Key('title'),
              controller: _title,
              maxLength: 80,
              decoration: const InputDecoration(labelText: 'Düğün adı', hintText: 'Ayşe & Mehmet'),
            ),
            if (_isNew) ...[
              TextField(
                key: const Key('contract'),
                controller: _contract,
                maxLength: 64,
                decoration: const InputDecoration(labelText: 'Sözleşme no (isteğe bağlı)', hintText: 'LS-2026-001'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<PackagePreset>(
                key: const Key('package'),
                initialValue: _package,
                decoration: const InputDecoration(labelText: 'Paket'),
                items: [for (final p in PackagePreset.values) DropdownMenuItem(value: p, child: Text(p.label))],
                onChanged: (v) => setState(() {
                  _package = v ?? _package;
                  _applyPreset();
                }),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Düğün günü'),
                subtitle: Text(dateFmt.format(_day)),
                trailing: TextButton(
                  key: const Key('wedding-day'),
                  child: const Text('Değiştir'),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _day,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      setState(() {
                        _day = d;
                        _applyPreset();
                      });
                    }
                  },
                ),
              ),
              Text(
                'Süreler paket ve düğün gününe göre önerildi; sözleşmeye göre değiştirebilirsiniz.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            _window(
              'A. Katılımcı Organizasyonu',
              'Program, duyurular, katılım yanıtları. Süre dışında kimse yazamaz.',
              _k,
              'katilimci',
              (w) => setState(() => _k = w),
            ),
            _window(
              'B. Anı Paylaşımı (yükleme süresi)',
              'Bu süre dışında yükleme kapanır; paylaşılan anılar süresiz görünür.',
              _p,
              'paylasim',
              (w) => setState(() => _p = w),
            ),
            SwitchListTile(
              key: const Key('approval'),
              title: const Text('Davetliler sahip onayıyla girsin'),
              value: _approval,
              onChanged: (v) => setState(() => _approval = v),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _error!,
                  key: const Key('form-error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('save'),
              onPressed: _saving ? null : _save,
              child: Text(_isNew ? 'Düğünü aç ve kodları oluştur' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
