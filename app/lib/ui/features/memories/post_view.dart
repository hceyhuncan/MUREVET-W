import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/memories_repository.dart';
import '../../../domain/models/memories.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'media_tile.dart';
import 'moderation.dart';

enum _PostAction { report, block, hide, unhide, delete }

enum _CommentAction { report, block, hide, delete }

/// Tek bir anı: medya, beğeni, yorumlar ve moderasyon.
class PostView extends StatefulWidget {
  const PostView({
    super.key,
    required this.weddingId,
    required this.uid,
    required this.isOwner,
    required this.post,
    required this.repo,
  });

  final String weddingId;
  final String uid;
  final bool isOwner;
  final Post post;
  final MemoriesRepository repo;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final _comment = TextEditingController();
  late final _liked = widget.repo.watchLiked(widget.weddingId, widget.post.id, widget.uid);
  late final _comments = widget.repo.watchComments(widget.weddingId, widget.post.id, includeHidden: widget.isOwner);
  late final _blocked = widget.repo.watchBlocked(widget.uid);
  late bool _hidden = widget.post.isHidden;
  int _likeDelta = 0;

  Post get p => widget.post;
  bool get _mine => p.authorUid == widget.uid;
  String get w => widget.weddingId;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _guard(Future<void> Function() f, {String? done}) async {
    final l = AppLocalizations.of(context);
    try {
      await f();
      if (done != null && mounted) toast(context, done);
    } catch (_) {
      if (mounted) toast(context, l.saveFailed);
    }
  }

  Future<void> _report(ReportTarget target, String id) async {
    final reason = await pickReportReason(context);
    if (reason == null || !mounted) return;
    await _guard(
      () => widget.repo.report(w, widget.uid, target, id, reason),
      done: AppLocalizations.of(context).reportSent,
    );
  }

  Future<void> _block(String otherUid, String name) async {
    final l = AppLocalizations.of(context);
    if (!await confirmDialog(context, l.blockUser, l.blockConfirm(name)) || !mounted) return;
    await _guard(() => widget.repo.block(widget.uid, otherUid), done: l.blocked);
  }

  Future<void> _onPostAction(_PostAction a) async {
    final l = AppLocalizations.of(context);
    switch (a) {
      case _PostAction.report:
        await _report(ReportTarget.post, p.id);
      case _PostAction.block:
        await _block(p.authorUid, p.authorName);
        if (mounted) Navigator.of(context).pop();
      case _PostAction.hide || _PostAction.unhide:
        final hide = a == _PostAction.hide;
        await _guard(() async {
          await widget.repo.setPostHidden(w, p.id, hidden: hide);
          if (mounted) setState(() => _hidden = hide);
        });
      case _PostAction.delete:
        if (!await confirmDialog(context, l.delete, l.deletePostConfirm) || !mounted) return;
        await _guard(() => widget.repo.deletePost(w, p));
        if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _send() async {
    final text = _comment.text.trim();
    if (text.isEmpty) return;
    await _guard(() async {
      await widget.repo.addComment(w, p.id, widget.uid, text);
      _comment.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = DateFormat('d MMMM, HH:mm', 'tr');
    return Scaffold(
      appBar: AppBar(
        title: Text(p.authorName),
        actions: [
          PopupMenuButton<_PostAction>(
            key: const Key('post-menu'),
            onSelected: _onPostAction,
            itemBuilder: (_) => [
              if (!_mine) PopupMenuItem(value: _PostAction.report, child: Text(l.report)),
              if (!_mine) PopupMenuItem(value: _PostAction.block, child: Text(l.blockUser)),
              if (widget.isOwner && !_hidden) PopupMenuItem(value: _PostAction.hide, child: Text(l.hide)),
              if (widget.isOwner && _hidden) PopupMenuItem(value: _PostAction.unhide, child: Text(l.unhide)),
              if (_mine || widget.isOwner) PopupMenuItem(value: _PostAction.delete, child: Text(l.delete)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                MediaFull(key: const ValueKey('media'), post: p, repo: widget.repo),
                if (_hidden)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(l.hiddenBadge, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                StreamBuilder<bool>(
                  key: const ValueKey('likes'),
                  stream: _liked,
                  builder: (context, snap) {
                    final liked = snap.data ?? false;
                    return ListTile(
                      leading: IconButton(
                        key: const Key('like'),
                        tooltip: l.like,
                        icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                        color: liked ? Colors.red : null,
                        onPressed: () => _guard(() async {
                          await widget.repo.setLiked(w, p.id, widget.uid, liked: !liked);
                          setState(() => _likeDelta += liked ? -1 : 1);
                        }),
                      ),
                      title: Text('${(p.likeCount + _likeDelta).clamp(0, 1 << 31)}'),
                      subtitle: Text(date.format(p.createdAt)),
                    );
                  },
                ),
                if (p.caption != null && p.caption!.isNotEmpty)
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(p.caption!)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(l.comments, style: Theme.of(context).textTheme.titleMedium),
                ),
                StreamBuilder<Set<String>>(
                  key: const ValueKey('comments'),
                  stream: _blocked,
                  initialData: const {},
                  builder: (context, bSnap) => StreamBuilder<List<PostComment>>(
                    stream: _comments,
                    builder: (context, snap) {
                      final blocked = bSnap.data ?? const {};
                      final list = (snap.data ?? const []).where((c) => !blocked.contains(c.authorUid)).toList();
                      if (list.isEmpty) {
                        return Padding(padding: const EdgeInsets.all(16), child: Text(l.noComments));
                      }
                      return Column(children: [for (final c in list) _commentTile(c)]);
                    },
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('comment-text'),
                      controller: _comment,
                      maxLength: 500,
                      decoration: InputDecoration(hintText: l.writeComment, counterText: ''),
                    ),
                  ),
                  IconButton(key: const Key('comment-send'), onPressed: _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentTile(PostComment c) {
    final l = AppLocalizations.of(context);
    final mine = c.authorUid == widget.uid;
    return ListTile(
      key: Key('comment-${c.id}'),
      title: Text(c.authorName),
      subtitle: Text(c.text, style: c.isHidden ? const TextStyle(fontStyle: FontStyle.italic) : null),
      trailing: PopupMenuButton<_CommentAction>(
        onSelected: (a) async {
          switch (a) {
            case _CommentAction.report:
              await _report(ReportTarget.comment, '${p.id}/${c.id}');
            case _CommentAction.block:
              await _block(c.authorUid, c.authorName);
            case _CommentAction.hide:
              await _guard(() => widget.repo.setCommentHidden(w, p.id, c.id, hidden: !c.isHidden));
            case _CommentAction.delete:
              if (await confirmDialog(context, l.delete, l.deleteCommentConfirm)) {
                await _guard(() => widget.repo.deleteComment(w, p.id, c.id));
              }
          }
        },
        itemBuilder: (_) => [
          if (!mine) PopupMenuItem(value: _CommentAction.report, child: Text(l.report)),
          if (!mine) PopupMenuItem(value: _CommentAction.block, child: Text(l.blockUser)),
          if (widget.isOwner) PopupMenuItem(value: _CommentAction.hide, child: Text(c.isHidden ? l.unhide : l.hide)),
          if (mine || widget.isOwner) PopupMenuItem(value: _CommentAction.delete, child: Text(l.delete)),
        ],
      ),
    );
  }
}
