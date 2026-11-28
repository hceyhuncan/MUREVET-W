import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';

import 'admin/firebase_admin_repository.dart';
import 'admin/ui/admin_app.dart';
import 'config/firebase_config.dart';

/// Yönetim paneli (web): flutter run -d chrome -t lib/main_admin.dart --dart-define=EMULATOR_HOST=127.0.0.1
/// Yayın: flutter build web -t lib/main_admin.dart  →  firebase deploy --only hosting:admin
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: demoOptions);
  final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
  if (useEmulator) {
    await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    functions.useFunctionsEmulator(emulatorHost, 5001);
  }
  runApp(AdminApp(repo: FirebaseAdminRepository(functions: functions)));
}
