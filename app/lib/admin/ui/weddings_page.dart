import 'package:material_ui/material_ui.dart';

import '../admin_models.dart';
import '../admin_repository.dart';
import 'common.dart';
import 'wedding_detail_page.dart';
import 'wedding_form_page.dart';

class WeddingsPage extends StatefulWidget {
  const WeddingsPage({super.key, required this.repo, required this.user, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AdminRepository repo;
  final AdminUser user;
  final DateTime Function() _clock;

  @override
  State<WeddingsPage> createState() => _WeddingsPageState();
}

class _WeddingsPageState extends State<WeddingsPage> {
  late final _weddings = widget.repo.watchWeddings();
  String _q = '';

  Future<void> _grantAdmin() async {
    final ctrl = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Yönetici ekle'),
        content: TextField(
          key: const Key('admin-email'),
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Google hesabı e-postası',
            helperText: 'Kişi panele en az bir kez giriş yapmış olmalı.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Vazgeç')),
          FilledButton(
            key: const Key('admin-grant'),
            onPressed: () => Navigator.pop(c, ctrl.text.trim()),
            child: const Text('Yetki ver'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !mounted) return;
    try {
      await widget.repo.grantAdmin(email);
      if (mounted) toast(context, '$email artık yönetici. Yeniden giriş yapınca yetki görünür.');
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Murevet Yönetim'),
        actions: [
          IconButton(
            key: const Key('grant-admin'),
            tooltip: 'Yönetici ekle',
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: _grantAdmin,
          ),
          TextButton(onPressed: widget.repo.signOut, child: Text('Çıkış (${widget.user.email ?? ''})')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('new-wedding'),
        icon: const Icon(Icons.add),
        label: const Text('Yeni düğün'),
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => WeddingFormPage(repo: widget.repo))),
      ),
      body: Narrow(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                key: const Key('search'),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Düğün adı veya sözleşme no',
                ),
                onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<AdminWedding>>(
                stream: _weddings,
                builder: (context, snap) {
                  if (snap.hasError) return Center(child: Text(errorText(snap.error!)));
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                  final now = widget._clock();
                  final list = snap.data!
                      .where(
                        (w) =>
                            _q.isEmpty ||
                            w.title.toLowerCase().contains(_q) ||
                            (w.contractRef ?? '').toLowerCase().contains(_q),
                      )
                      .toList();
                  if (list.isEmpty) return const Center(child: Text('Düğün yok.'));
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final w = list[i];
                      return ListTile(
                        key: Key('wedding-${w.id}'),
                        title: Text(w.title),
                        subtitle: Text(
                          '${w.packageLabel}${w.contractRef == null ? '' : ' · ${w.contractRef}'}\n'
                          'A: ${windowState(w.katilimci, now)} · B yükleme: ${windowState(w.paylasim, now)}',
                        ),
                        isThreeLine: true,
                        trailing: Chip(label: Text(w.isActive ? 'Aktif' : 'Kapalı')),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => WeddingDetailPage(repo: widget.repo, weddingId: w.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
