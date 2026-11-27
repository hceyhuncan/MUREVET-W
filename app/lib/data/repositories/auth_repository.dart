import 'dart:async';

/// Oturum bilgisi. Uygulamanın geri kalanı Firebase'e doğrudan bağlı değildir.
class AppUser {
  const AppUser({required this.uid, this.displayName, this.email});
  final String uid;
  final String? displayName;
  final String? email;
}

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<AppUser> signInWithGoogle();
  Future<void> signOut();
  /// Hesabı ve tüm kişisel verileri sunucuda siler (Play + KVKK).
  Future<void> deleteAccount();
}
