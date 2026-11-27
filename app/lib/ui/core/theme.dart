import 'package:material_ui/material_ui.dart';

/// Murevet tasarım token'ları (ilk sürüm; UX/UI ajanı tasarım sistemiyle güncelleyecek).
class MurevetColors {
  static const ivory = Color(0xFFFBF7F2);
  static const ink = Color(0xFF2B2420);
  static const rose = Color(0xFFB76E79);
  static const gold = Color(0xFFC9A66B);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: MurevetColors.rose,
    surface: MurevetColors.ivory,
    onSurface: MurevetColors.ink,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: MurevetColors.ivory,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
    ),
  );
}
