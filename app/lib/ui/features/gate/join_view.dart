import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/join_result.dart';
import '../../../domain/models/membership.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'join_view_model.dart';

class JoinView extends StatefulWidget {
  const JoinView({super.key, required this.viewModel});

  final JoinViewModel viewModel;

  @override
  State<JoinView> createState() => _JoinViewState();
}

class _JoinViewState extends State<JoinView> {
  late final _code = TextEditingController(text: widget.viewModel.code);
  late final _name = TextEditingController();

  JoinViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    vm.prefillName();
    _name.text = vm.name;
    vm.addListener(_onChange);
  }

  void _onChange() {
    final r = vm.result;
    if (r == null || !mounted) return;
    vm.result = null;
    if (r.status == MemberStatus.pending) {
      context.go('/w/${r.weddingId}/pending');
    } else {
      context.go('/w/${r.weddingId}');
    }
  }

  @override
  void dispose() {
    vm.removeListener(_onChange);
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  String? _errorText(AppLocalizations l) => switch (vm.joinError) {
        JoinError.notFound => l.errorCodeNotFound,
        JoinError.tooManyAttempts => l.errorTooManyAttempts,
        JoinError.weddingClosed => l.errorWeddingClosed,
        JoinError.removed => l.errorRemoved,
        null => null,
        _ => l.errorGeneric,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.codeTitle)),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          final err = _errorText(l);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                key: const Key('join-code'),
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: l.codeHint,
                  errorText: vm.fieldError == JoinFieldError.codeFormat ? l.codeInvalidFormat : null,
                ),
                onChanged: (v) => vm.code = v,
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('join-name'),
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l.nameLabel,
                  helperText: l.nameHint,
                  errorText: vm.fieldError == JoinFieldError.nameRequired ? l.nameRequired : null,
                ),
                onChanged: (v) => vm.name = v,
              ),
              const SizedBox(height: 24),
              if (err != null) ...[
                Text(err, key: const Key('join-error'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 12),
              ],
              if (!vm.signedIn) ...[
                Text(l.signInRequired),
                const SizedBox(height: 12),
              ],
              FilledButton(
                key: const Key('join-submit'),
                onPressed: vm.busy ? null : vm.submit,
                child: vm.busy
                    ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(vm.signedIn ? l.join : l.signInWithGoogle),
              ),
            ],
          );
        },
      ),
    );
  }
}
