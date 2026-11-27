import 'package:firebase_core/firebase_core.dart';

/// Firebase projesi henüz açılmadı (HESAPLAR.md #5). Gerçek proje açılınca bu dosya
/// `flutterfire configure` ile üretilen firebase_options.dart ile değiştirilecek.
/// Şimdilik yerel emülatörler için demo proje kullanılır:
///   flutter run --dart-define=USE_EMULATOR=true
const useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: true);
const emulatorHost = String.fromEnvironment('EMULATOR_HOST', defaultValue: '10.0.2.2');

const demoOptions = FirebaseOptions(
  apiKey: 'demo-key',
  appId: '1:000000000000:android:0000000000000000',
  messagingSenderId: '000000000000',
  projectId: 'demo-murevet',
  storageBucket: 'demo-murevet.appspot.com',
);
