import 'package:fitoraa/features/export.dart';

class AppFonts {
  static const String heading = 'Sora';
  static const String body = 'Inter';

  ThemeData apptheme = ThemeData(
    scaffoldBackgroundColor: AppColors.lightBackgroundSecondary,
      useMaterial3: true,

      fontFamily: AppFonts.body,

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.heading,
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),

        displayMedium: TextStyle(
          fontFamily: AppFonts.heading,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),

        headlineLarge: TextStyle(
          fontFamily: AppFonts.heading,
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.heading,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),

        titleLarge: TextStyle(
          fontFamily: AppFonts.heading,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),

        bodyLarge: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),

        bodyMedium: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
  );
}