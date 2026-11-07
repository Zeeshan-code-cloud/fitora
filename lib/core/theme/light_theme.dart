import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    primaryColor: const Color(0xFF4CAF50),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    cardColor: Colors.white,

    dividerColor: const Color(0xFFE5E7EB),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF22C55E),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFF111827),
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF374151),
      ),
    ),
  );
}