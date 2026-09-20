import 'package:anyhoo_design_system/src/theme/colors/controls_colors.dart';
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

final darkNavyAppColors = AppColors(
  // ---------------------------------------------------------------------------
  // Surface Colors (Dark Slate & Navy-Grey Base)
  // ---------------------------------------------------------------------------
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFF0B0E14), // Deep navy-black background
    lowContrastBackground: Color(0xFF121824), // Slightly lighter navy background
    primaryText: Color(0xFFEDF2F7), // High-contrast cool white
    secondaryText: Color(0xFFA0AEC0), // Muted slate grey
    containerLowest: Color(0xFF0F141F), // Slightly distinct from scaffold
    containerLow: Color(0xFF171E2C), // Standard card/container surface
    containerHigh: Color(0xFF222B3E), // Elevated components
    containerHighest: Color(0xFF2D374D), // Modals, popups, and dropdowns
    outline: Color(0xFF2A364F), // Subtle dark blue-grey borders
    secondaryContainer: Color(0xFF1E293B), // Low-key secondary container
    onSecondaryContainer: Color(0xFFCBD5E1), // Secondary container text
    inverseSurface: Color(0xFFE2E8F0), // Light surface for inverse elements
    inverseOnSurface: Color(0xFF0F172A), // Dark text on inverse surface
  ),

  // ---------------------------------------------------------------------------
  // Accent Colors (Primary Navy Blue & Ice Blue Highlights)
  // ---------------------------------------------------------------------------
  accent: const AccentColors(
    primaryFixed: Color(0xFF2563EB), // Royal navy blue brand color
    onPrimaryFixed: Color(0xFFFFFFFF), // Text on primary fixed
    primaryDisabled: Color(0xFF1E293B), // Muted navy for disabled state
    onPrimaryDisabled: Color(0xFF64748B), // Text on disabled state
    primaryContainer: Color(0xFF1E3A8A), // Deep navy accent background
    onPrimaryContainer: Color(0xFFDBEAFE), // Light ice blue text on container
    headline: Color(0xFF3B82F6), // Bright blue for highlighted text
    inversePrimary: Color(0xFF93C5FD), // Ice blue for light/inverse contexts
  ),

  // ---------------------------------------------------------------------------
  // Status Colors (Standard Visual Feedback)
  // ---------------------------------------------------------------------------
  status: const StatusColors(
    error: Color(0xFFEF4444), // Soft red
    errorContainer: Color(0xFF450A0A), // Deep dark red
    warning: Color(0xFFF59E0B), // Amber warning
    success: Color(0xFF10B981), // Muted emerald green
  ),

  // ---------------------------------------------------------------------------
  // Shimmer Colors (Loading Visuals)
  // ---------------------------------------------------------------------------
  shimmer: const ShimmerColors(
    baseColor: Color(0xFF1E293B), // Dark slate shimmer base
    highlightColor: Color(0xFF334155), // Shimmer sweep highlight
  ),

  // ---------------------------------------------------------------------------
  // AppBar Colors (Top and Bottom Navigation)
  // ---------------------------------------------------------------------------
  appBar: const AppBarColors(
    topBarBackground: Color(0xFF0F172A), // Slate-navy top app bar
    topBarBorder: Color(0xFF1E293B), // Divider below top app bar
    topBarText: Color(0xFFF8FAFC), // Title text
    backButtonColor: Color(0xFF94A3B8), // Muted icon color
    avatarColor: Color(0xFF2563EB), // Avatar ring/background accent
    bottomBarBackground: Color(0xFF0F172A), // Bottom navigation bar
    bottomBarIconColors: Color(0xFF94A3B8), // Unselected bottom icons
    bottomBarIndicatorColor: Color(0xFF1E3A8A), // Active tab pill background
    bottomBarBorderColor: Color(0xFF1E293B), // Divider above bottom bar
  ),

  // ---------------------------------------------------------------------------
  // Component Controls Colors
  // ---------------------------------------------------------------------------
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(
      background: Color(0xFF334155), // Inactive track
      button: Color(0xFF3B82F6), // Active thumb color
    ),
    cardColors: ColorSet(
      background: Color(0xFF171E2C), // Dark container surface
      foreground: Color(0xFFF1F5F9), // Card text/content
      borderColor: Color(0xFF222B3E), // Card border
    ),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFF0F172A), foreground: Color(0xFF94A3B8), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFF2563EB), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF3B82F6)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFF1E293B), foreground: Color(0xFF94A3B8), borderColor: Color(0xFF334155)),
      selected: ColorSet(background: Color(0xFF2563EB), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF60A5FA)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFF1E3A8A), foreground: Color(0xFFBFDBFE), borderColor: Color(0xFF2563EB)),
      secondary: ColorSet(background: Color(0xFF1E293B), foreground: Color(0xFFCBD5E1), borderColor: Color(0xFF334155)),
      error: ColorSet(background: Color(0xFF450A0A), foreground: Color(0xFFFECACA), borderColor: Color(0xFF991B1B)),
      warning: ColorSet(background: Color(0xFF451A03), foreground: Color(0xFFFDE68A), borderColor: Color(0xFF92400E)),
      inactive: ColorSet(background: Color(0xFF0F172A), foreground: Color(0xFF64748B), borderColor: Color(0xFF1E293B)),
    ),
  ),
);
