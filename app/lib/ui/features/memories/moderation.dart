import 'package:material_ui/material_ui.dart';

import '../../../domain/models/memories.dart';
import '../../../l10n/gen/app_localizations.dart';

Future<bool> confirmDialog(BuildContext context, String title, String body) async {
  final l = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        FilledButton(key: const Key('confirm'), onPressed: () => Navigator.pop(c, true), child: Text(title)),
      ],
    ),
  );
  return ok ?? false;
}

/// Şikayet nedeni seçimi (Play UGC politikası: uygulama içi şikayet zorunlu).
Future<ReportReason?> pickReportReason(BuildContext context) {
  final l = AppLocalizations.of(context);
  final labels = {
    ReportReason.inappropriate: l.reasonInappropriate,
    ReportReason.harassment: l.reasonHarassment,
    ReportReason.nudity: l.reasonNudity,
    ReportReason.copyright: l.reasonCopyright,
    ReportReason.other: l.reasonOther,
  };
  return showDialog<ReportReason>(
    context: context,
    builder: (c) => SimpleDialog(
      title: Text(l.reportTitle),
      children: [
        for (final e in labels.entries)
          SimpleDialogOption(
            key: Key('reason-${e.key.name}'),
            onPressed: () => Navigator.pop(c, e.key),
            child: Text(e.value),
          ),
      ],
    ),
  );
}

void toast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
