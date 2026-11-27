import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/memories_repository.dart';
import '../../../data/services/media_picker.dart';
import '../../../domain/models/memories.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'media_tile.dart';
import 'moderation.dart';
import 'post_view.dart';

/// Modül B: Anı Paylaşımı sekmesi. Görüntüleme süresiz; [canUpload] yükleme penceresini yansıtır.
class MemoriesView extends StatefulWidget {
  const MemoriesView({
    super.key,
    required this.weddingId,
    required this.uid,
    required this.isOwner,
    required this.canUpload,
    required this.repo,
    required this.picker,
  });

  final String weddingId;
  final String uid;
  final bool isOwner;
  final bool canUpload;
  final MemoriesRepository repo;
  final MediaPicker picker;

  @override
  State<MemoriesView> createState() => _MemoriesViewState();
}

class _MemoriesViewState extends State<MemoriesView> {
  double? _progress;
  late final Stream<List<Post>> _posts = widget.repo.watchPosts(widget.weddingId, includeHidden: widget.isOwner);
  late final Stream<Set<String>> _blocked = widget.repo.watchBlocked(widget.uid);

  Future<void> _add() async {
    final l = AppLocalizations.of(context);
    final picked = await widget.picker.pick();
    if (!mounted || picked.isEmpty) return;
    final ok = picked.where((m) => m.isAllowed).toList();
    if (ok.length < picked.length) toast(context, l.fileTooLarge);
    if (ok.isEmpty) return;

    final caption = TextEditingController();
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.selectedCount(ok.length)),
        content: TextField(
          key: const Key('caption'),
          controller: caption,
          maxLength: 500,
          decoration: InputDecoration(hintText: l.captionHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(key: const Key('upload-share'), onPressed: () => Navigator.pop(c, true), child: Text(l.share)),
        ],
      ),
    );
    if (go != true || !mounted) return;
    setState(() => _progress = 0);
    try {
      await widget.repo.upload(
        widget.weddingId,
        widget.uid,
        ok,
        caption: caption.text.trim(),
        onProgress: (p) => mounted ? setState(() => _progress = p) : null,
      );
      if (mounted) toast(context, l.uploadDone(ok.length));
    } catch (_) {
      if (mounted) toast(context, l.uploadFailed);
    } finally {
      if (mounted) setState(() => _progress = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      floatingActionButton: widget.canUpload && _progress == null
          ? FloatingActionButton.extended(
              key: const Key('add-memory'),
              onPressed: _add,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(l.addMemory),
            )
          : null,
      body: Column(
        children: [
          if (_progress != null) ...[
            LinearProgressIndicator(value: _progress),
            Padding(padding: const EdgeInsets.all(8), child: Text(l.uploading((_progress! * 100).round()))),
          ],
          if (!widget.canUpload)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(l.uploadClosed, style: Theme.of(context).textTheme.bodySmall),
            ),
          Expanded(
            child: StreamBuilder<Set<String>>(
              stream: _blocked,
              initialData: const {},
              builder: (context, bSnap) => StreamBuilder<List<Post>>(
                stream: _posts,
                builder: (context, snap) {
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                  final blocked = bSnap.data ?? const {};
                  final posts = snap.data!.where((p) => !blocked.contains(p.authorUid)).toList();
                  if (posts.isEmpty) {
                    return Center(
                      child: Padding(padding: const EdgeInsets.all(24), child: Text(l.noMemories)),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(2),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, i) => InkWell(
                      key: Key('post-${posts[i].id}'),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PostView(
                            weddingId: widget.weddingId,
                            uid: widget.uid,
                            isOwner: widget.isOwner,
                            post: posts[i],
                            repo: widget.repo,
                          ),
                        ),
                      ),
                      child: MediaTile(post: posts[i], repo: widget.repo),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
