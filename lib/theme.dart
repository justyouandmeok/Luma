import 'package:flutter/material.dart';

class OndaColors {
  static const bg = Color(0xFF0E0E0E);
  static const surface = Color(0xFF1A1A1A);
  static const card = Color(0xFF242424);
  static const accent = Color(0xFFFF2D55);
  static const text = Color(0xFFF2F2F2);
  static const muted = Color(0xFF9A9A9A);
}

ThemeData ondaTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: OndaColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: OndaColors.accent,
      surface: OndaColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: OndaColors.bg,
      foregroundColor: OndaColors.text,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: OndaColors.surface,
      indicatorColor: OndaColors.accent.withValues(alpha: 0.2),
    ),
  );
}
