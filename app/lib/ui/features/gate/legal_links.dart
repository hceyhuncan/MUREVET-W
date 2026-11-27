import 'package:material_ui/material_ui.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Yasal metin bağlantıları. URL'ler Firebase Hosting'de yayınlanınca bağlanacak.
class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key, this.onOpen});

  final void Function(String key)? onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        TextButton(onPressed: () => onOpen?.call('privacy'), child: Text(l.privacyPolicy)),
        TextButton(onPressed: () => onOpen?.call('terms'), child: Text(l.terms)),
        TextButton(onPressed: () => onOpen?.call('kvkk'), child: Text(l.kvkkNotice)),
      ],
    );
  }
}
