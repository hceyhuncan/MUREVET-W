import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/program_repository.dart';
import '../data/repositories/wedding_repository.dart';
import '../domain/models/membership.dart';
import '../l10n/gen/app_localizations.dart';
import 'core/theme.dart';
import 'features/gate/gate_view.dart';
import 'features/gate/join_view.dart';
import 'features/gate/join_view_model.dart';
import 'features/settings/settings_view.dart';
import 'features/wedding_home/wedding_home_view.dart';
import 'features/weddings/my_weddings_view.dart';
import 'features/weddings/pending_view.dart';

class MurevetApp extends StatefulWidget {
  const MurevetApp({super.key, required this.auth, required this.weddings, required this.program});

  final AuthRepository auth;
  final WeddingRepository weddings;
  final ProgramRepository program;

  @override
  State<MurevetApp> createState() => _MurevetAppState();
}

class _MurevetAppState extends State<MurevetApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (c, s) => _Root(auth: widget.auth, weddings: widget.weddings),
      ),
      // Bağlantı: /join?code=ABCD234 (QR ve paylaşılan bağlantılar buraya açılır)
      GoRoute(
        path: '/join',
        builder: (c, s) => JoinView(
          viewModel: JoinViewModel(
            auth: widget.auth,
            weddings: widget.weddings,
            initialCode: s.uri.queryParameters['code'],
          ),
        ),
      ),
      GoRoute(
        path: '/w/:id',
        redirect: (c, s) => widget.auth.currentUser == null ? '/' : null,
        builder: (c, s) {
          final id = s.pathParameters['id']!;
          final uid = widget.auth.currentUser!.uid;
          return WeddingHomeView(
            wedding: widget.weddings.watchWedding(id),
            membership: widget.weddings.watchMembership(id, uid),
            uid: uid,
            program: widget.program,
          );
        },
      ),
      GoRoute(
        path: '/w/:id/pending',
        redirect: (c, s) => widget.auth.currentUser == null ? '/' : null,
        builder: (c, s) => PendingView(
          weddingId: s.pathParameters['id']!,
          membership: widget.weddings.watchMembership(s.pathParameters['id']!, widget.auth.currentUser!.uid),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (c, s) => SettingsView(auth: widget.auth),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Murevet',
      theme: buildTheme(),
      routerConfig: _router,
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

/// Kök: kodu ve üyeliği olmayan herkes ön modülde kalır.
class _Root extends StatelessWidget {
  const _Root({required this.auth, required this.weddings});

  final AuthRepository auth;
  final WeddingRepository weddings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: auth.authStateChanges(),
      initialData: auth.currentUser,
      builder: (context, userSnap) {
        final user = userSnap.data;
        if (user == null) return const GateView();
        return StreamBuilder<List<Membership>>(
          stream: weddings.watchMemberships(user.uid),
          builder: (context, snap) {
            if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
            final list = snap.data!;
            if (list.isEmpty) return const GateView();
            return MyWeddingsView(memberships: list);
          },
        );
      },
    );
  }
}
