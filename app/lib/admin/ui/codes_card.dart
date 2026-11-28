import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../admin_models.dart';
import 'common.dart';

/// Sahip ve davetli kodları. Sahip kodu sadece düğün sahiplerine ofiste teslim edilir.
class CodesView extends StatelessWidget {
  const CodesView({super.key, required this.codes, this.onRotateGuest});
  final InviteCodes codes;
  final VoidCallback? onRotateGuest;

  Widget _row(BuildContext context, String label, String? code, String hint, String key, {Widget? extra}) {
    return ListTile(
      title: Text(label),
      subtitle: Text(hint),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            code ?? '-',
            key: Key(key),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'monospace', letterSpacing: 2),
          ),
          IconButton(
            tooltip: 'Kopyala',
            icon: const Icon(Icons.copy),
            onPressed: code == null
                ? null
                : () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) toast(context, '$label kopyalandı.');
                  },
          ),
          ?extra,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(context, 'Sahip kodu', codes.ownerCode, 'En fazla 2 kişi. Sadece çifte teslim edin.', 'owner-code'),
        _row(
          context,
          'Davetli kodu',
          codes.guestCode,
          'Davetiye ve masalarda paylaşılır.',
          'guest-code',
          extra: onRotateGuest == null
              ? null
              : IconButton(
                  key: const Key('rotate-guest'),
                  tooltip: 'Yeni davetli kodu',
                  icon: const Icon(Icons.refresh),
                  onPressed: onRotateGuest,
                ),
        ),
      ],
    );
  }
}
