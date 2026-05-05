import 'package:flutter/material.dart';

import 'verse_grid_theme.dart';

/// Default colors from **Цветовая палитра — HRISHIKESH SWAMI** (design PDF).
///
/// Host apps may use [lightColorScheme] / [lightTheme] as-is or mix these
/// [Color] constants into custom themes.
abstract final class VerseGridColorPalette {
  VerseGridColorPalette._();

  /// `#3A5A40`
  static const Color forest = Color(0xFF3A5A40);

  /// `#38573D`
  static const Color forestMid = Color(0xFF38573D);

  /// `#304B35`
  static const Color forestDeep = Color(0xFF304B35);

  /// `#EEB844`
  static const Color goldBright = Color(0xFFEEB844);

  /// `#EAA81C`
  static const Color gold = Color(0xFFEAA81C);

  /// `#CD9213`
  static const Color goldDeep = Color(0xFFCD9213);

  /// `#FFFFFF`
  static const Color paper = Color(0xFFFFFFFF);

  /// `#343A40`
  static const Color ink = Color(0xFF343A40);

  /// `#000000`
  static const Color black = Color(0xFF000000);

  /// Light Material color scheme built from the palette tokens.
  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      primary: forest,
      onPrimary: paper,
      primaryContainer: forestMid,
      onPrimaryContainer: paper,
      secondary: gold,
      onSecondary: ink,
      secondaryContainer: goldBright,
      onSecondaryContainer: ink,
      tertiary: goldDeep,
      onTertiary: paper,
      surface: paper,
      onSurface: ink,
      onSurfaceVariant: forestMid,
      outline: forestDeep,
      outlineVariant: Color.alphaBlend(
        forestMid.withValues(alpha: 0.35),
        paper,
      ),
      error: const Color(0xFFB3261E),
      onError: paper,
    );
  }

  /// Default package theme: Material 3 + [lightColorScheme] + [VerseGridTheme].
  static ThemeData lightTheme({
    VerseGridTheme verseGridExtension = const VerseGridTheme(),
  }) {
    final scheme = lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
      ),
      extensions: <ThemeExtension<dynamic>>[
        verseGridExtension,
      ],
    );
  }
}
