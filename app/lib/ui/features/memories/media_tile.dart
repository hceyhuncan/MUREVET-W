import 'package:material_ui/material_ui.dart';
import 'package:video_player/video_player.dart';

import '../../../data/repositories/memories_repository.dart';
import '../../../domain/models/memories.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Izgaradaki küçük kare. Videolar için oynat simgesi gösterilir.
class MediaTile extends StatelessWidget {
  const MediaTile({super.key, required this.post, required this.repo});
  final Post post;
  final MemoriesRepository repo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Widget content = post.mediaType == MediaType.video
        ? ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: Center(child: Icon(Icons.play_circle_outline, size: 40, color: scheme.onSurfaceVariant)),
          )
        : _NetworkImage(path: post.mediaPath, repo: repo, fit: BoxFit.cover);
    return Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (post.isHidden)
          ColoredBox(
            color: Colors.black54,
            child: Icon(Icons.visibility_off_outlined, color: scheme.onPrimary),
          ),
      ],
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({required this.path, required this.repo, required this.fit});
  final String path;
  final MemoriesRepository repo;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(child: Icon(Icons.image_outlined, color: scheme.onSurfaceVariant)),
    );
    return FutureBuilder<String?>(
      future: repo.mediaUrl(path),
      builder: (context, snap) {
        final url = snap.data;
        if (url == null) return placeholder;
        return Image.network(url, fit: fit, errorBuilder: (_, _, _) => placeholder);
      },
    );
  }
}

/// Gönderi ekranındaki büyük medya.
class MediaFull extends StatelessWidget {
  const MediaFull({super.key, required this.post, required this.repo});
  final Post post;
  final MemoriesRepository repo;

  @override
  Widget build(BuildContext context) {
    if (post.mediaType == MediaType.image) {
      return InteractiveViewer(
        child: _NetworkImage(path: post.mediaPath, repo: repo, fit: BoxFit.contain),
      );
    }
    return FutureBuilder<String?>(
      future: repo.mediaUrl(post.mediaPath),
      builder: (context, snap) => snap.data == null
          ? AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(child: Text(AppLocalizations.of(context).videoLabel)),
            )
          : _VideoPlayer(url: snap.data!),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({required this.url});
  final String url;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController _c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _c.initialize().then((_) => mounted ? setState(() {}) : null).catchError((_) {
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return Center(child: Text(AppLocalizations.of(context).mediaUnavailable));
    if (!_c.value.isInitialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AspectRatio(
      aspectRatio: _c.value.aspectRatio,
      child: GestureDetector(
        onTap: () => setState(() => _c.value.isPlaying ? _c.pause() : _c.play()),
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_c),
            if (!_c.value.isPlaying) const Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
