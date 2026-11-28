import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/models/wedding.dart';

final dateTimeFmt = DateFormat('d MMM y HH:mm', 'tr');
final dateFmt = DateFormat('d MMMM y', 'tr');

/// Geniş ekranda içeriği ortalar (panel masaüstü tarayıcıda kullanılır).
class Narrow extends StatelessWidget {
  const Narrow({super.key, required this.child, this.maxWidth = 960});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

String windowState(ModuleWindow w, DateTime now) {
  if (!w.enabled) return 'Sözleşmede yok';
  if (now.isBefore(w.start)) return 'Başlamadı';
  if (now.isAfter(w.end)) return 'Süresi doldu';
  return 'Açık';
}

String windowText(ModuleWindow w) => '${dateTimeFmt.format(w.start)} → ${dateTimeFmt.format(w.end)}';

Future<bool> confirm(BuildContext context, String title, String body, {String? action}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Vazgeç')),
        FilledButton(key: const Key('confirm'), onPressed: () => Navigator.pop(c, true), child: Text(action ?? title)),
      ],
    ),
  );
  return ok ?? false;
}

void toast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

/// Sunucu hatasını kısa bir Türkçe mesaja çevirir.
String errorText(Object e) {
  final s = e.toString();
  if (s.contains('permission-denied')) return 'Yetkiniz yok.';
  if (s.contains('invalid-argument')) return 'Bilgiler geçersiz. Tarihleri kontrol edin.';
  if (s.contains('not-found')) return 'Kayıt bulunamadı.';
  return 'İşlem başarısız oldu. Tekrar deneyin.';
}
