// lib/src/theme/colors/app_colors.dart
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'surface_colors.tailor.dart';

@immutable
@TailorMixinComponent()
class SurfaceColors extends ThemeExtension<SurfaceColors> with _$SurfaceColorsTailorMixin {
  const SurfaceColors({
    required this.scaffoldBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBackground,
    required this.cardBorder,
    required this.outline,
  });

  @override
  final Color scaffoldBackground;
  @override
  final Color primaryText;
  @override
  final Color secondaryText;
  @override
  final Color cardBackground;
  @override
  final Color cardBorder;
  @override
  final Color outline;
}
