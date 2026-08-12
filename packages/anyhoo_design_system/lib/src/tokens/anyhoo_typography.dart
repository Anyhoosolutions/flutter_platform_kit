import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

enum DisplaySize { large, medium }

enum HeadlineSize { large, medium, small, tiny }

enum BodySize { large, medium }

enum LabelSize { large, medium }

/// Kinetic Logic typography scale (Inter).
///
/// Prefer [HeadlineSize.medium] on narrow/mobile viewports; Kinetic's
/// `headline-lg-mobile` matches medium (24/32). Use [HeadlineSize.large] for
/// the full desktop `headline-lg` (28/36).
abstract final class AnyhooTypography {
  static TextStyle display(DisplaySize size) {
    return switch (size) {
      DisplaySize.large => _style(fontSize: 48, lineHeight: 56, fontWeight: FontWeight.w700, letterSpacingEm: -0.02),
      DisplaySize.medium => _style(fontSize: 36, lineHeight: 44, fontWeight: FontWeight.w700, letterSpacingEm: -0.02),
    };
  }

  static TextStyle headline(HeadlineSize size) {
    return switch (size) {
      HeadlineSize.large => _style(fontSize: 28, lineHeight: 36, fontWeight: FontWeight.w600, letterSpacingEm: -0.01),
      HeadlineSize.medium => _style(fontSize: 24, lineHeight: 32, fontWeight: FontWeight.w600),
      HeadlineSize.small => _style(fontSize: 20, lineHeight: 28, fontWeight: FontWeight.w600),
      HeadlineSize.tiny => _style(fontSize: 16, lineHeight: 24, fontWeight: FontWeight.w600),
    };
  }

  static TextStyle body(BodySize size) {
    return switch (size) {
      BodySize.large => _style(fontSize: 16, lineHeight: 24, fontWeight: FontWeight.w400),
      BodySize.medium => _style(fontSize: 14, lineHeight: 20, fontWeight: FontWeight.w400),
    };
  }

  static TextStyle label(LabelSize size) {
    return switch (size) {
      LabelSize.large => _style(fontSize: 14, lineHeight: 20, fontWeight: FontWeight.w500, letterSpacingPx: 0.1),
      LabelSize.medium => _style(fontSize: 12, lineHeight: 16, fontWeight: FontWeight.w500, letterSpacingPx: 0.5),
    };
  }

  static TextStyle _style({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
    double? letterSpacingEm,
    double? letterSpacingPx,
  }) {
    return AppFonts.inter.copyWith(
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacingPx ?? (letterSpacingEm != null ? letterSpacingEm * fontSize : null),
    );
  }
}
