import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';
import 'colors/app_colors.dart';
import 'colors/default_app_colors.dart';

/// Configurable ThemeData factory for Anyhoo applications.
class AnyhooTheme {
  static ThemeData light({AppColors? colors, List<ThemeExtension<dynamic>>? extraExtensions}) {
    return _build(brightness: Brightness.light, colors: colors ?? defaultLightColors, extraExtensions: extraExtensions);
  }

  static ThemeData dark({AppColors? colors, List<ThemeExtension<dynamic>>? extraExtensions}) {
    return _build(brightness: Brightness.dark, colors: colors ?? defaultDarkColors, extraExtensions: extraExtensions);
  }

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
    List<ThemeExtension<dynamic>>? extraExtensions,
  }) {
    final surface = colors.surface;
    final accent = colors.accent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: surface.scaffoldBackground,
      extensions: <ThemeExtension<dynamic>>[colors, ...?extraExtensions],
      appBarTheme: AppBarTheme(
        backgroundColor: surface.scaffoldBackground,
        foregroundColor: surface.primaryText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: surface.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          side: BorderSide(color: surface.cardBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent.primaryFixed,
          foregroundColor: accent.onPrimaryFixed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusLg)),
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd, horizontal: DesignTokens.spacingLg),
        ),
      ),
    );
  }
}
