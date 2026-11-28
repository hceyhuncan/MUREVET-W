import 'package:material_ui/material_ui.dart';

import '../admin_models.dart';
import '../admin_repository.dart';
import 'codes_card.dart';
import 'common.dart';
import 'wedding_form_page.dart';

const _reasonLabels = {
  'inappropriate': 'Uygunsuz içerik',
  'harassment': 'Taciz',
  'nudity': 'Çıplaklık',
  'copyright': 'Telif',
  'other': 'Diğer',
};

class WeddingDetailPage extends StatelessWidget {
  const WeddingDetailPage({super.key, required this.repo, required this.weddingId, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AdminRepository repo;
  final String weddingId;
  final DateTime Function() _clock;

  Future<void> _run(BuildContext context, Future<void> Function() f, String done) async {
    try {
      await f();
      if (context.mounted) toast(context, done);
    } catch (e) {
      if (context.mounted) toast(context, errorText(e));
    }
  }

  Widget _section(BuildContext context, String title, Widget child) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          child,
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AdminWedding?>(
      stream: repo.watchWedding(weddingId),
      builder: (context, snap) {
        final w = snap.data;
        if (w == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final now = _clock();
        return Scaffold(
          appBar: AppBar(
            title: Text(w.title),
            actions: [
              TextButton.icon(
                key: const Key('edit'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Düzenle'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => WeddingFormPage(repo: repo, initial: w),
                  ),
                ),
              ),
            ],
          ),
          body: Narrow(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _section(
                  context,
                  'Genel',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paket: ${w.packageLabel}'),
                      if (w.contractRef != null) Text('Sözleşme: ${w.contractRef}'),
                      Text(w.requireApproval ? 'Davetliler onayla girer' : 'Davetliler kodla doğrudan girer'),
                      Text(w.isActive ? 'Durum: Aktif' : 'Durum: Kapalı (kimse yazamaz)', key: const Key('status')),
                      StreamBuilder<AdminMemberCounts>(
                        stream: repo.watchMemberCounts(weddingId),
                        builder: (context, s) => s.hasData
                            ? Text(
                                'Üyeler: ${s.data!.active} aktif, ${s.data!.pending} onay bekliyor, ${s.data!.owners} sahip',
                                key: const Key('member-counts'),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('toggle-active'),
                        onPressed: () async {
                          final close = w.isActive;
                          final ok = await confirm(
                            context,
                            close ? 'Düğünü kapat' : 'Düğünü yeniden aç',
                            close
                                ? 'Kapalı düğünde kimse yeni içerik ekleyemez veya değiştiremez. Üyeler görüntülemeye devam eder.'
                                : 'Düğün yeniden yazmaya açılır (modül süreleri yine geçerlidir).',
                          );
                          if (ok && context.mounted) {
                            await _run(context, () => repo.setActive(weddingId, active: !close), 'Kaydedildi.');
                          }
                        },
                        child: Text(w.isActive ? 'Düğünü kapat' : 'Düğünü yeniden aç'),
                      ),
                    ],
                  ),
                ),
                _section(
                  context,
                  'Modüller',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('A. Katılımcı Organizasyonu · ${windowState(w.katilimci, now)}'),
                        subtitle: Text(windowText(w.katilimci)),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('B. Anı yükleme · ${windowState(w.paylasim, now)}'),
                        subtitle: Text(windowText(w.paylasim)),
                      ),
                    ],
                  ),
                ),
                _section(
                  context,
                  'Kodlar',
                  StreamBuilder<InviteCodes>(
                    stream: repo.watchCodes(weddingId),
                    builder: (context, s) => CodesView(
                      codes: s.data ?? const InviteCodes(),
                      onRotateGuest: () async {
                        final ok = await confirm(
                          context,
                          'Yeni davetli kodu',
                          'Eski davetli kodu çalışmayı durdurur. Daha önce katılanlar etkilenmez.',
                          action: 'Yenile',
                        );
                        if (ok && context.mounted) {
                          await _run(context, () => repo.rotateGuestCode(weddingId), 'Yeni davetli kodu oluşturuldu.');
                        }
                      },
                    ),
                  ),
                ),
                _section(
                  context,
                  'Şikayetler',
                  StreamBuilder<List<AdminReport>>(
                    stream: repo.watchReports(weddingId),
                    builder: (context, s) {
                      final list = s.data ?? const [];
                      if (list.isEmpty) return const Text('Şikayet yok.');
                      return Column(
                        children: [
                          for (final r in list)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.flag_outlined),
                              title: Text('${_reasonLabels[r.reason] ?? r.reason} · ${r.targetType}'),
                              subtitle: Text('${r.targetId} · ${dateTimeFmt.format(r.createdAt)}'),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
