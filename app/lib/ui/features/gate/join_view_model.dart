import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/wedding_repository.dart';
import '../../../domain/code_format.dart';
import '../../../domain/models/join_result.dart';

enum JoinFieldError { codeFormat, nameRequired }

class JoinViewModel extends ChangeNotifier {
  JoinViewModel({required AuthRepository auth, required WeddingRepository weddings, String? initialCode})
      : _auth = auth, // ignore: prefer_initializing_formals
        _weddings = weddings, // ignore: prefer_initializing_formals
        code = initialCode ?? '';

  final AuthRepository _auth;
  final WeddingRepository _weddings;

  String code;
  String name = '';
  bool busy = false;
  JoinFieldError? fieldError;
  JoinError? joinError;
  JoinResult? result;

  bool get signedIn => _auth.currentUser != null;

  void prefillName() {
    if (name.isEmpty) name = _auth.currentUser?.displayName ?? '';
  }

  /// Kodu doğrular, gerekirse Google ile giriş yaptırır ve katılır.
  Future<void> submit() async {
    fieldError = null;
    joinError = null;
    final normalized = normalizeCode(code);
    if (normalized == null) {
      fieldError = JoinFieldError.codeFormat;
      notifyListeners();
      return;
    }
    busy = true;
    notifyListeners();
    try {
      if (!signedIn) {
        await _auth.signInWithGoogle();
        prefillName();
      }
      if (name.trim().isEmpty) {
        fieldError = JoinFieldError.nameRequired;
        return;
      }
      result = await _weddings.joinWithCode(code: normalized, displayName: name.trim());
    } on JoinException catch (e) {
      joinError = e.error;
    } catch (_) {
      joinError = JoinError.generic;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
