import 'package:flutter/material.dart';

/// Design tokens (approximate) derived from provided Figma frames.
/// Replace with exact values once hex codes are confirmed.
class AppTheme {
  // Core palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111111); // main text
  static const Color greyText = Color(0xFF6E6E6E); // secondary text
  static const Color border = Color(0xFFE1E4E8);
  static const Color subtleBg = Color(0xFFF7F8FA); // light component bg
  static const Color danger = Color(0xFFFF4A4A); // red toggles / alerts
  static const Color accentBlueRing = Color(0xFFFFD3D3); // updated pink ring
  static const Color accentOrangeRing =
      Color(0xFFFF6A3D); // avatar ring orange (unchanged)
  static const Color calendarEvent =
      Color(0xFFF44336); // red accent (Yandex style)

  // Legacy aliases (for existing screens before refactor)
  static const Color primary = calendarEvent; // backward compatibility
  static const Color primaryText = black; // backward compatibility
  static const Color secondaryText = greyText; // backward compatibility

  // Spacing scale
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;

  // Radius
  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 28; // large top corners for modal sheets

  // Typography (placeholder values)
  static const TextStyle h1 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: black);
  static const TextStyle h2 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black);
  static const TextStyle body =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black);
  static const TextStyle bodySecondary =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: greyText);
  static const TextStyle caption =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: greyText);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: white,
    primaryColor: calendarEvent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: calendarEvent,
      brightness: Brightness.light,
    ).copyWith(
      secondary: danger,
      error: danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      foregroundColor: black,
      centerTitle: false,
      titleTextStyle: h2,
    ),
    textTheme: const TextTheme(
      titleLarge: h2,
      bodyMedium: body,
      bodySmall: caption,
    ),
    dividerColor: border,
    cardTheme: const CardThemeData(
      color: white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
      ),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: calendarEvent,
      foregroundColor: white,
      elevation: 6,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: subtleBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: s12, vertical: s8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: const BorderSide(color: calendarEvent, width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? danger : Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? danger.withValues(alpha: 0.30)
              : border),
    ),
  );
}
