import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../core/theme.dart';
import 'legal_links.dart';

/// Ön modül: kodu olmayan kullanıcının gördüğü tek ekran.
/// Asıl uygulamaya, menülere veya herhangi bir düğün içeriğine erişim yoktur.
/// Play ödeme politikası gereği burada fiyat veya satın alma yönlendirmesi yoktur.
class GateView extends StatelessWidget {
  const GateView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(l.appName,
                  textAlign: TextAlign.center,
                  style: text.displaySmall?.copyWith(color: MurevetColors.rose, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Text(l.gateTitle, textAlign: TextAlign.center, style: text.headlineSmall),
              const SizedBox(height: 12),
              Text(l.gateBody, textAlign: TextAlign.center, style: text.bodyLarge),
              const Spacer(),
              FilledButton(
                key: const Key('gate-have-code'),
                onPressed: () => context.push('/join'),
                child: Text(l.gateHaveCode),
              ),
              const SizedBox(height: 12),
              Text(l.gateNoCode, textAlign: TextAlign.center, style: text.bodyMedium),
              const SizedBox(height: 24),
              const LegalLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
