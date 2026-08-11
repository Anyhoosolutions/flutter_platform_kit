import 'package:flutter/material.dart';

/// Raw design tokens for spacing, radii, and core fallback colors.
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

  // Fallback Raw Colors
  static const backgroundDark = Color(0xFF111508);
  static const backgroundLight = Color(0xFFF5F5F0);
  static const primaryLime = Color(0xFFC3F400);
  static const primaryLimeDim = Color(0xFFABD600);
  static const onPrimaryDark = Color(0xFF161E00);
  static const errorRed = Color(0xFFDE301D);
}
