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
);

const defaultStatusColors = StatusColors(
  error: DesignTokens.errorRed,
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

/// Dark surfaces derived from Kinetic Logic inverse / on-surface tokens.
const defaultDarkColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: DesignTokens.backgroundDark,
    lowContrastBackground: Color(0xFF131B2E), // on-surface
    primaryText: Color(0xFFEEF0FF), // inverse-on-surface
    secondaryText: Color(0xFFB7C8E1), // secondary-fixed-dim
    cardBackground: Color(0xFF1A2336),
    cardBorder: Color(0xFF424754), // on-surface-variant
    containerHigh: Color(0xFF283044), // inverse-surface
    containerLow: Color(0xFF161C2A),
    containerHighest: Color(0xFF38485D), // on-secondary-fixed-variant
    containerLowest: Color(0xFF0A0E16),
    outline: Color(0xFF727785),
    topBarBackground: DesignTokens.backgroundDark,
    topBarText: Color(0xFFEEF0FF),
    bottomBarBackground: DesignTokens.backgroundDark,
    bottomBarIconColors: Color(0xFFEEF0FF),
  ),
  accent: AccentColors(
    primaryFixed: DesignTokens.primaryFixedDim,
    onPrimaryFixed: DesignTokens.onPrimaryFixed,
    primaryDisabled: Color(0xFF004395),
    onPrimaryDisabled: DesignTokens.primaryFixed,
    primaryContainer: DesignTokens.primary,
    onPrimaryContainer: DesignTokens.onPrimaryContainer,
    headline: DesignTokens.primaryFixedDim,
  ),
  status: StatusColors(
    error: Color(0xFFFFB4AB),
    warning: Color(0xFFFBBF24),
    success: DesignTokens.primaryFixedDim,
  ),
  shimmer: ShimmerColors(baseColor: Color(0xFF1A2336), highlightColor: Color(0xFF283044)),
  appBar: AppBarColors(
    topBarBackground: DesignTokens.backgroundDark,
    topBarBorder: Color(0xFF424754),
    topBarText: Color(0xFFEEF0FF),
    backButtonColor: Color(0xFFEEF0FF),
    iconColor: DesignTokens.primaryFixedDim,
    bottomBarBackground: DesignTokens.backgroundDark,
    bottomBarIconColors: Color(0xFFEEF0FF),
  ),
);
