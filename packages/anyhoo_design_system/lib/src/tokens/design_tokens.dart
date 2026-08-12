import 'package:flutter/material.dart';

/// Raw design tokens for spacing, radii, and core fallback colors.
///
/// Color values follow the Kinetic Logic palette from Stitch.
abstract final class DesignTokens {
  // Spacing Scale
  static const spacingXs = 4.0;
  static const spacingSm = 8.0;
  static const spacingMd = 16.0;
  static const spacingLg = 24.0;
  static const spacingXl = 40.0;
  static const spacingGutter = 12.0;
  static const marginMobile = 16.0;

  // Radius Scale
  static const radiusSm = 4.0;
  static const radiusMd = 8.0;
  static const radiusLg = 12.0;
  static const radiusXl = 16.0;

  // Kinetic Logic fallback colors
  static const backgroundLight = Color(0xFFFAF8FF);
  static const backgroundDark = Color(0xFF0F141F);
  static const primary = Color(0xFF0058BE);
  static const primaryContainer = Color(0xFF2170E4);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFFFEFCFF);
  static const onPrimaryFixed = Color(0xFF001A42);
  static const primaryFixed = Color(0xFFD8E2FF);
  static const primaryFixedDim = Color(0xFFADC6FF);
  static const onPrimaryFixedVariant = Color(0xFF004395);
  static const errorRed = Color(0xFFBA1A1A);
}
