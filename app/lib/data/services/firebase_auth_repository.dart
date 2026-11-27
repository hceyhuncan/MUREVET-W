import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFunctions? functions, GoogleSignIn? google})
      : _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1'),
        _google = google ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;
  final GoogleSignIn _google;
  bool _googleReady = false;

  AppUser? _map(User? u) => u == null ? null : AppUser(uid: u.uid, displayName: u.displayName, email: u.email);

  @override
  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  AppUser? get currentUser => _map(_auth.currentUser);

  @override
  Future<AppUser> signInWithGoogle() async {
    if (!_googleReady) {
      await _google.initialize();
      _googleReady = true;
    }
    final account = await _google.authenticate();
    final credential = GoogleAuthProvider.credential(idToken: account.authentication.idToken);
    final result = await _auth.signInWithCredential(credential);
    return _map(result.user)!;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (_googleReady) await _google.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _functions.httpsCallable('deleteAccount').call<void>();
    await signOut();
  }
}
