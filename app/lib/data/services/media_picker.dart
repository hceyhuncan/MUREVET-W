import 'package:image_picker/image_picker.dart';

import '../../domain/models/memories.dart';

/// Galeriden fotoğraf/video seçimi. Android'de sistem Fotoğraf Seçici'yi kullanır,
/// bu yüzden depolama izni istenmez (Play medya izni politikası).
abstract class MediaPicker {
  Future<List<PickedMedia>> pick();
}

class ImagePickerMediaPicker implements MediaPicker {
  ImagePickerMediaPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  static String _mime(XFile f) {
    if (f.mimeType != null && f.mimeType!.isNotEmpty) return f.mimeType!;
    final n = f.name.toLowerCase();
    if (n.endsWith('.png')) return 'image/png';
    if (n.endsWith('.webp')) return 'image/webp';
    if (n.endsWith('.heic')) return 'image/heic';
    if (n.endsWith('.gif')) return 'image/gif';
    if (n.endsWith('.mp4') || n.endsWith('.m4v')) return 'video/mp4';
    if (n.endsWith('.mov')) return 'video/quicktime';
    if (n.endsWith('.webm')) return 'video/webm';
    if (n.endsWith('.3gp')) return 'video/3gpp';
    return 'image/jpeg';
  }

  @override
  Future<List<PickedMedia>> pick() async {
    final files = await _picker.pickMultipleMedia(imageQuality: 85, maxWidth: 2560, maxHeight: 2560, limit: 20);
    return [for (final f in files) PickedMedia(name: f.name, mimeType: _mime(f), size: await f.length(), path: f.path)];
  }
}
