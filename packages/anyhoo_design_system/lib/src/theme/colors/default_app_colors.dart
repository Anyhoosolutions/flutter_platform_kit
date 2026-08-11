import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import 'app_colors.dart';

const defaultAccentColors = AccentColors(
  primaryFixed: DesignTokens.primaryLime,
  onPrimaryFixed: DesignTokens.onPrimaryDark,
  primaryDisabled: Color.fromARGB(255, 142, 170, 31),
  onPrimaryDisabled: Color.fromARGB(255, 41, 51, 14),
  primaryContainer: DesignTokens.primaryLime,
  onPrimaryContainer: Color(0xFF556D00),
  headline: Colors.white,
);

const defaultStatusColors = StatusColors(
  error: DesignTokens.errorRed,
  warning: Color(0xFFF59E0B),
  success: DesignTokens.primaryLime,
);

const defaultLightColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFFF5F5F0),
    lowContrastBackground: Color(0xFFE9E9DF),
    primaryText: Color(0xFF111508),
    secondaryText: Color(0xFF444933),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFF8E9379),
    containerHigh: Color(0xFFE8E8E0),
    containerLow: Color(0xFFF0F0EA),
    containerHighest: Color(0xFFD8D8D0),
    containerLowest: Color(0xFFFFFFFF),
    outline: Color(0xFF8E9379),
  ),
  accent: defaultAccentColors,
  status: defaultStatusColors,
  shimmer: ShimmerColors(baseColor: Color(0xFFF3F4F6), highlightColor: Color(0xFFE5E7EB)),
);

const defaultDarkColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: DesignTokens.backgroundDark,
    lowContrastBackground: Color(0xFF131311),
    primaryText: Color(0xFFE2E4CF),
    secondaryText: Color(0xFFC4C9AC),
    cardBackground: Color(0xFF1E2113),
    cardBorder: Color(0xFF444933),
    containerHigh: Color(0xFF282B1D),
    containerLow: Color(0xFF1A1D10),
    containerHighest: Color(0xFF333627),
    containerLowest: Color(0xFF0C0F04),
    outline: Color(0xFF8E9379),
  ),
  accent: defaultAccentColors,
  status: defaultStatusColors,
  shimmer: ShimmerColors(baseColor: Color(0xFF282B1D), highlightColor: Color(0xFF333627)),
);
