import 'package:fitoraa/features/export.dart';

import '../core/theme/theme_controller.dart';
class AppColors {
  AppColors._();

  // ============================================================
  // BRAND
  // ============================================================

  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryDark = Color(0xFF4549C8);
  static const Color primaryLight = Color(0xFF7A7DFF);

  static const Color accent = Color(0xFF36D7FF);
  static const Color accentDark = Color(0xFF19B8E5);
  static const Color accentLight = Color(0xFF78E5FF);

  // ============================================================
  // SECONDARY
  // ============================================================

  static const Color secondaryPurple = Color(0xFF7C4DFF);
  static const Color secondaryBlue = Color(0xFF3C79F5);
  static const Color secondaryCyan = Color(0xFF36D7FF);

  // ============================================================
  // SEMANTIC
  // ============================================================

  static const Color success = Color(0xFF39D98A);
  static const Color successDark = Color(0xFF1DA968);
  static const Color successLight = Color(0xFF70E6AD);

  static const Color warning = Color(0xFFFFB547);
  static const Color warningDark = Color(0xFFE39116);
  static const Color warningLight = Color(0xFFFFCC78);

  static const Color danger = Color(0xFFFF647C);
  static const Color dangerDark = Color(0xFFE6425D);
  static const Color dangerLight = Color(0xFFFF8FA0);

  static const Color info = Color(0xFF4EA7FF);

  // ============================================================
  // LIGHT MODE
  // ============================================================

  static const Color lightBackground = Color(0xFFF4F6FF);
  static const Color lightBackgroundSecondary = Color(0xFFEEF5FF);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFF9FAFF);

  static const Color lightTextPrimary = Color(0xFF10152F);
  static const Color lightTextSecondary = Color(0xFF66708F);
  static const Color lightTextMuted = Color(0xFF9299B3);

  static const Color lightBorder = Color(0xFFDDE1F0);
  static const Color lightDivider = Color(0xFFE5E8F3);

  // ============================================================
  // DARK MODE
  // ============================================================

  static const Color darkBackground = Color(0xFF080C1C);
  static const Color darkBackgroundSecondary = Color(0xFF10162A);

  static const Color darkSurface = Color(0xFF11172B);
  static const Color darkSurfaceSecondary = Color(0xFF171E35);

  static const Color darkTextPrimary = Color(0xFFF7F8FF);
  static const Color darkTextSecondary = Color(0xFFA8B0CC);
  static const Color darkTextMuted = Color(0xFF707A9C);

  static const Color darkBorder = Color(0xFF252D48);
  static const Color darkDivider = Color(0xFF202840);

  // ============================================================
  // GLASS - LIGHT
  // ============================================================

  static const Color glassLight = Color(0x33FFFFFF); // 20%
  static const Color glassLightSmall = Color(0x2EFFFFFF); // 18%
  static const Color glassLightMedium = Color(0x33FFFFFF); // 20%
  static const Color glassLightLarge = Color(0x40FFFFFF); // 25%

  static const Color glassBorderLight = Color(0x4DFFFFFF); // 30%
  static const Color glassHighlightLight = Color(0x66FFFFFF); // 40%

  // ============================================================
  // GLASS - DARK
  // ============================================================

  static const Color glassDark = Color(0x14FFFFFF); // 8%
  static const Color glassDarkSmall = Color(0x12FFFFFF); // 7%
  static const Color glassDarkMedium = Color(0x17FFFFFF); // 9%
  static const Color glassDarkLarge = Color(0x1FFFFFFF); // 12%

  static const Color glassBorderDark = Color(0x2EFFFFFF); // 18%
  static const Color glassHighlightDark = Color(0x3DFFFFFF); // 24%

  // ============================================================
  // OVERLAYS
  // ============================================================

  static const Color overlayBlack10 = Color(0x1A000000);
  static const Color overlayBlack20 = Color(0x33000000);
  static const Color overlayBlack30 = Color(0x4D000000);

  static const Color overlayWhite10 = Color(0x1AFFFFFF);
  static const Color overlayWhite20 = Color(0x33FFFFFF);
  static const Color overlayWhite30 = Color(0x4DFFFFFF);

  // ============================================================
  // GRADIENTS
  // ============================================================

  // Main brand gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5148D8),
      Color(0xFF3C79F5),
      Color(0xFF36D7FF),
    ],
  );

  // Primary button gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5B5FEF),
      Color(0xFF7C4DFF),
    ],
  );

  // Progress gradient
  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5B5FEF),
      Color(0xFF36D7FF),
    ],
  );

  // Purple gradient
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5148D8),
      Color(0xFF7C4DFF),
    ],
  );

  // Blue gradient
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3C79F5),
      Color(0xFF36D7FF),
    ],
  );

  // Success gradient
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF39D98A),
      Color(0xFF36D7FF),
    ],
  );

  // Water gradient
  static const LinearGradient waterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF78E5FF),
      Color(0xFF36D7FF),
      Color(0xFF3C79F5),
    ],
  );

  // Light app background gradient
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF7F5FF),
      Color(0xFFEEF5FF),
    ],
  );

  // Dark app background gradient
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF18123F),
      Color(0xFF101D4C),
      Color(0xFF062D43),
    ],
  );

  // ============================================================
  // SPECIAL FITNESS COLORS
  // ============================================================

  static const Color steps = Color(0xFF5B5FEF);
  static const Color calories = Color(0xFFFF647C);
  static const Color distance = Color(0xFF36D7FF);
  static const Color activeMinutes = Color(0xFF39D98A);
  static const Color hydration = Color(0xFF36D7FF);
  static const Color workout = Color(0xFF7C4DFF);
  static const Color heartRate = Color(0xFFFF647C);

  // ============================================================
  // CHART COLORS
  // ============================================================

  static const List<Color> chartGradient = [
    Color(0xFF5B5FEF),
    Color(0xFF36D7FF),
  ];

  static const List<Color> chartColors = [
    Color(0xFF5B5FEF),
    Color(0xFF36D7FF),
    Color(0xFF39D98A),
    Color(0xFFFFB547),
    Color(0xFFFF647C),
  ];

  // ============================================================
  // SHADOW COLORS
  // ============================================================

  static const Color shadowLight = Color(0x1A111A45);
  static const Color shadowMedium = Color(0x26111A45);
  static const Color shadowDark = Color(0x3310183E);

  // ============================================================
  // DISABLED
  // ============================================================

  static const Color disabledLight = Color(0xFFD0D5E5);
  static const Color disabledDark = Color(0xFF3A425D);

  // ============================================================
  // COMMON
  // ============================================================

  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;


  // ============================================================
// THEME GETTERS
// ============================================================

  static bool get isDark {
    if (Get.isRegistered<ThemeController>()) {
      return Get.find<ThemeController>().isDarkMode.value;
    }
    return Get.isDarkMode;
  }

// Backgrounds
  static Color get background =>
      isDark ? darkBackground : lightBackground;

  static Color get backgroundSecondary =>
      isDark
          ? darkBackgroundSecondary
          : lightBackgroundSecondary;

// Surfaces / Cards
  static Color get surface =>
      isDark ? darkSurface : lightSurface;

  static Color get surfaceSecondary =>
      isDark
          ? darkSurfaceSecondary
          : lightSurfaceSecondary;

// Text
  static Color get textPrimary =>
      isDark
          ? darkTextPrimary
          : lightTextPrimary;

  static Color get textSecondary =>
      isDark
          ? darkTextSecondary
          : lightTextSecondary;

  static Color get textMuted =>
      isDark
          ? darkTextMuted
          : lightTextMuted;

// Borders
  static Color get border =>
      isDark ? darkBorder : lightBorder;

  static Color get divider =>
      isDark ? darkDivider : lightDivider;

// Glass
  static Color get glass =>
      isDark ? glassDark : glassLight;

  static Color get glassSmall =>
      isDark ? glassDarkSmall : glassLightSmall;

  static Color get glassMedium =>
      isDark ? glassDarkMedium : glassLightMedium;

  static Color get glassLarge =>
      isDark ? glassDarkLarge : glassLightLarge;

  static Color get glassBorder =>
      isDark
          ? glassBorderDark
          : glassBorderLight;

  static Color get glassHighlight =>
      isDark
          ? glassHighlightDark
          : glassHighlightLight;

// Disabled
  static Color get disabled =>
      isDark
          ? disabledDark
          : disabledLight;

// Shadows
  static Color get shadow =>
      isDark
          ? shadowDark
          : shadowLight;

// Overlay
  static Color get overlay =>
      isDark
          ? overlayBlack20
          : overlayWhite20;

// Background Gradient
  static LinearGradient get backgroundGradient =>
      isDark
          ? darkBackgroundGradient
          : lightBackgroundGradient;

}

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,

    cardColor: AppColors.lightSurface,

    dividerColor: AppColors.lightDivider,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(
        color: AppColors.lightTextSecondary,
      ),
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    primaryColor: AppColors.primary,

    cardColor: AppColors.darkSurface,

    dividerColor: AppColors.darkDivider,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        color: AppColors.darkTextSecondary,
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
  );
}
