import 'package:flutter/material.dart';

class AppDarkTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0F172A),

    primaryColor: const Color(0xFF4CAF50),

    cardColor: const Color(0xFF1E293B),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF22C55E),
    ),
  );
}