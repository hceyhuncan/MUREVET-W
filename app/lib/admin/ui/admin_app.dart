import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';

import '../../ui/core/theme.dart';
import '../admin_models.dart';
import '../admin_repository.dart';
import 'weddings_page.dart';

/// Lotus ekibinin web yönetim paneli. Sadece `admin: true` özel alanı olan hesaplar girer;
/// asıl yetki kontrolü sunucu fonksiyonlarında ve güvenlik kurallarındadır.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key, required this.repo, this.clock});
  final AdminRepository repo;
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murevet Yönetim',
      theme: buildTheme(),
      locale: const Locale('tr'),
      supportedLocales: const [Locale('tr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder<AdminUser?>(
        stream: repo.watchUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final u = snap.data;
          if (u == null) return _SignIn(repo: repo);
          if (!u.isAdmin) return _NoAccess(repo: repo, email: u.email);
          return WeddingsPage(repo: repo, user: u, clock: clock);
        },
      ),
    );
  }
}

class _SignIn extends StatelessWidget {
  const _SignIn({required this.repo});
  final AdminRepository repo;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Murevet Yönetim', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Sadece Lotus ekibi içindir.'),
          const SizedBox(height: 24),
          FilledButton.icon(
            key: const Key('admin-sign-in'),
            icon: const Icon(Icons.login),
            label: const Text('Google ile giriş'),
            onPressed: repo.signIn,
          ),
        ],
      ),
    ),
  );
}

class _NoAccess extends StatelessWidget {
  const _NoAccess({required this.repo, this.email});
  final AdminRepository repo;
  final String? email;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${email ?? 'Bu hesap'} yönetici değil.', key: const Key('no-access')),
          const SizedBox(height: 8),
          const Text('Bir yöneticiden yetki isteyin, sonra tekrar giriş yapın.'),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: repo.signOut, child: const Text('Çıkış')),
        ],
      ),
    ),
  );
}
