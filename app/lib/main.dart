import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_ui/material_ui.dart';

import 'config/firebase_config.dart';
import 'data/services/firebase_auth_repository.dart';
import 'data/services/firestore_memories_repository.dart';
import 'data/services/firestore_program_repository.dart';
import 'data/services/media_picker.dart';
import 'data/services/firestore_wedding_repository.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: demoOptions);
  final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
  if (useEmulator) {
    await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    functions.useFunctionsEmulator(emulatorHost, 5001);
    await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
  }
  runApp(
    MurevetApp(
      auth: FirebaseAuthRepository(functions: functions),
      weddings: FirestoreWeddingRepository(functions: functions),
      program: FirestoreProgramRepository(functions: functions),
      memories: FirestoreMemoriesRepository(),
      picker: ImagePickerMediaPicker(),
    ),
  );
}
