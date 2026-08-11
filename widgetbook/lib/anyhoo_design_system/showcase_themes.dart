import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Named theme options available in design-system Widgetbook showcases.
enum ShowcaseThemeOption {
  defaults('Default'),
  slateSky('Slate + Sky'),
  warmTerracotta('Warm Terracotta');

  const ShowcaseThemeOption(this.label);

  final String label;

  static ShowcaseThemeOption fromLabel(String label) {
    return ShowcaseThemeOption.values.firstWhere((option) => option.label == label);
  }

  ThemeData lightTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.light(),
      ShowcaseThemeOption.slateSky => AnyhooTheme.light(colors: slateSkyColors),
      ShowcaseThemeOption.warmTerracotta => AnyhooTheme.light(colors: warmTerracottaColors),
    };
  }

  ThemeData darkTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.dark(),
      ShowcaseThemeOption.slateSky => AnyhooTheme.dark(colors: slateSkyDarkColors),
      ShowcaseThemeOption.warmTerracotta => AnyhooTheme.dark(colors: warmTerracottaDarkColors),
    };
  }
}

/// Slate surfaces with a sky-blue accent (from the design system guide).
const slateSkyColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFFF8FAFC),
    lowContrastBackground: Color(0xFFF1F5F9),
    primaryText: Color(0xFF0F172A),
    secondaryText: Color(0xFF475569),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2E8F0),
    containerHigh: Color(0xFFE2E8F0),
    containerLow: Color(0xFFF1F5F9),
    containerHighest: Color(0xFFCBD5E1),
    containerLowest: Color(0xFFFFFFFF),
    outline: Color(0xFF94A3B8),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFF0284C7),
    onPrimaryFixed: Color(0xFFFFFFFF),
    primaryDisabled: Color(0xFFBAE6FD),
    onPrimaryDisabled: Color(0xFF0369A1),
    primaryContainer: Color(0xFFE0F2FE),
    onPrimaryContainer: Color(0xFF0369A1),
    headline: Color(0xFF0F172A),
  ),
  status: StatusColors(
    error: Color(0xFFEF4444),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF10B981),
  ),
  shimmer: ShimmerColors(
    baseColor: Color(0xFFE2E8F0),
    highlightColor: Color(0xFFF1F5F9),
  ),
);

const slateSkyDarkColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFF0F172A),
    lowContrastBackground: Color(0xFF1E293B),
    primaryText: Color(0xFFF8FAFC),
    secondaryText: Color(0xFFCBD5E1),
    cardBackground: Color(0xFF1E293B),
    cardBorder: Color(0xFF334155),
    containerHigh: Color(0xFF334155),
    containerLow: Color(0xFF1E293B),
    containerHighest: Color(0xFF475569),
    containerLowest: Color(0xFF020617),
    outline: Color(0xFF64748B),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFF38BDF8),
    onPrimaryFixed: Color(0xFF0C4A6E),
    primaryDisabled: Color(0xFF0E7490),
    onPrimaryDisabled: Color(0xFFBAE6FD),
    primaryContainer: Color(0xFF075985),
    onPrimaryContainer: Color(0xFFE0F2FE),
    headline: Color(0xFFF8FAFC),
  ),
  status: StatusColors(
    error: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    success: Color(0xFF34D399),
  ),
  shimmer: ShimmerColors(
    baseColor: Color(0xFF1E293B),
    highlightColor: Color(0xFF334155),
  ),
);

/// Warm cream surfaces with a terracotta accent.
const warmTerracottaColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFFFAF7F2),
    lowContrastBackground: Color(0xFFF0E6DA),
    primaryText: Color(0xFF2C1810),
    secondaryText: Color(0xFF6B4F3F),
    cardBackground: Color(0xFFFFFBF7),
    cardBorder: Color(0xFFD4C4B0),
    containerHigh: Color(0xFFE8D9C8),
    containerLow: Color(0xFFF5EDE3),
    containerHighest: Color(0xFFD4C4B0),
    containerLowest: Color(0xFFFFFBF7),
    outline: Color(0xFFA89080),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFFC45C26),
    onPrimaryFixed: Color(0xFFFFFBF7),
    primaryDisabled: Color(0xFFE8B89A),
    onPrimaryDisabled: Color(0xFF8B3A14),
    primaryContainer: Color(0xFFFCE8DC),
    onPrimaryContainer: Color(0xFF8B3A14),
    headline: Color(0xFF2C1810),
  ),
  status: StatusColors(
    error: Color(0xFFDC2626),
    warning: Color(0xFFD97706),
    success: Color(0xFF059669),
  ),
  shimmer: ShimmerColors(
    baseColor: Color(0xFFE8D9C8),
    highlightColor: Color(0xFFF5EDE3),
  ),
);

const warmTerracottaDarkColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFF1A120E),
    lowContrastBackground: Color(0xFF241A14),
    primaryText: Color(0xFFF5EDE3),
    secondaryText: Color(0xFFD4C4B0),
    cardBackground: Color(0xFF2C1F18),
    cardBorder: Color(0xFF4A372C),
    containerHigh: Color(0xFF3D2C22),
    containerLow: Color(0xFF241A14),
    containerHighest: Color(0xFF4A372C),
    containerLowest: Color(0xFF120C09),
    outline: Color(0xFF8B6F5C),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFFE07A45),
    onPrimaryFixed: Color(0xFF2C1810),
    primaryDisabled: Color(0xFF8B4A2E),
    onPrimaryDisabled: Color(0xFFFCE8DC),
    primaryContainer: Color(0xFF8B3A14),
    onPrimaryContainer: Color(0xFFFCE8DC),
    headline: Color(0xFFF5EDE3),
  ),
  status: StatusColors(
    error: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    success: Color(0xFF34D399),
  ),
  shimmer: ShimmerColors(
    baseColor: Color(0xFF2C1F18),
    highlightColor: Color(0xFF3D2C22),
  ),
);
