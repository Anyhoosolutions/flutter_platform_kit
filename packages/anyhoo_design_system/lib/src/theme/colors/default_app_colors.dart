import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import 'app_colors.dart';

/// Default accent colors from Kinetic Logic.
///
/// Note: [AccentColors.primaryFixed] is the solid primary action color
/// (Kinetic `primary`), not Material 3's light `primary-fixed` token.
const defaultAccentColors = AccentColors(
  primaryFixed: DesignTokens.primary,
  onPrimaryFixed: DesignTokens.onPrimary,
  primaryDisabled: DesignTokens.primaryFixedDim,
  onPrimaryDisabled: DesignTokens.onPrimaryFixedVariant,
  primaryContainer: DesignTokens.primaryContainer,
  onPrimaryContainer: DesignTokens.onPrimaryContainer,
  headline: DesignTokens.primary,
  inversePrimary: DesignTokens.inversePrimary,
);

const defaultStatusColors = StatusColors(
  error: Color(0xFF93000a),
  errorContainer: Color(0xFFffdad6),
  warning: Color(0xFFF59E0B),
  success: Color(0xFF2170E4),
);

const defaultLightColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFFFAF8FF), // surface / background
    lowContrastBackground: Color(0xFFD2D9F4), // surface-dim
    primaryText: Color(0xFF131B2E), // on-surface
    secondaryText: Color(0xFF424754), // on-surface-variant
    cardBackground: Color(0xFFFFFFFF), // surface-container-lowest
    cardBorder: Color(0xFFC2C6D6), // outline-variant
    containerHigh: Color(0xFFE2E7FF), // surface-container-high
    containerLow: Color(0xFFF2F3FF), // surface-container-low
    containerHighest: Color(0xFFDAE2FD), // surface-container-highest
    containerLowest: Color(0xFFFFFFFF), // surface-container-lowest
    outline: Color(0xFF727785), // outline
    secondaryContainer: DesignTokens.secondaryContainer,
    onSecondaryContainer: DesignTokens.onSecondaryContainer,
    inverseSurface: DesignTokens.inverseSurface,
    inverseOnSurface: DesignTokens.inverseOnSurface,
    topBarBackground: Color(0xFFFAF8FF),
    topBarText: Color(0xFF131B2E),
    bottomBarBackground: Color(0xFFFAF8FF),
    bottomBarIconColors: Color(0xFF131B2E),
  ),
  appBar: AppBarColors(
    topBarBackground: Color(0xFFFAF8FF),
    topBarBorder: Color(0xFFC2C6D6),
    topBarText: Color(0xFF131B2E),
    backButtonColor: Color(0xFF131B2E),
    iconColor: Color(0xFF0058BE),
    bottomBarBackground: Color(0xFFFAF8FF),
    bottomBarIconColors: Color(0xFF131B2E),
  ),
  accent: defaultAccentColors,
  status: defaultStatusColors,
  shimmer: ShimmerColors(baseColor: Color(0xFFE2E7FF), highlightColor: Color(0xFFF2F3FF)),
);

/// Dark palette from Kinetic Logic Dark (Obsidian / tonal elevation).
const defaultDarkColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFF0B1326), // background / surface
    lowContrastBackground: Color(0xFF0B1326), // surface-dim
    primaryText: Color(0xFFDAE2FD), // on-surface
    secondaryText: Color(0xFFC2C6D6), // on-surface-variant
    cardBackground: Color(0xFF171F33), // surface-container
    cardBorder: Color(0xFF424754), // outline-variant
    containerHigh: Color(0xFF222A3D), // surface-container-high
    containerLow: Color(0xFF131B2E), // surface-container-low
    containerHighest: Color(0xFF2D3449), // surface-container-highest
    containerLowest: Color(0xFF060E20), // surface-container-lowest
    outline: Color(0xFF8C909F), // outline
    secondaryContainer: Color(0xFF3131C0),
    onSecondaryContainer: Color(0xFFB0B2FF),
    inverseSurface: Color(0xFFDAE2FD),
    inverseOnSurface: Color(0xFF283044),
    topBarBackground: Color(0xFF0B1326),
    topBarText: Color(0xFFDAE2FD),
    bottomBarBackground: Color(0xFF0B1326),
    bottomBarIconColors: Color(0xFFDAE2FD),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFFADC6FF), // primary
    onPrimaryFixed: Color(0xFF002E6A), // on-primary
    primaryDisabled: Color(0xFF004395),
    onPrimaryDisabled: Color(0xFFD8E2FF),
    primaryContainer: Color(0xFF4D8EFF),
    onPrimaryContainer: Color(0xFF00285D),
    headline: Color(0xFFADC6FF),
    inversePrimary: Color(0xFF005AC2),
  ),
  status: StatusColors(
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    warning: Color(0xFFFFB786),
    success: Color(0xFF4D8EFF),
  ),
  shimmer: ShimmerColors(baseColor: Color(0xFF171F33), highlightColor: Color(0xFF222A3D)),
  appBar: AppBarColors(
    topBarBackground: Color(0xFF0B1326),
    topBarBorder: Color(0xFF424754),
    topBarText: Color(0xFFDAE2FD),
    backButtonColor: Color(0xFFDAE2FD),
    iconColor: Color(0xFFADC6FF),
    bottomBarBackground: Color(0xFF0B1326),
    bottomBarIconColors: Color(0xFFDAE2FD),
  ),
);
