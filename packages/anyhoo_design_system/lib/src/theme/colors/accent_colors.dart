import 'package:anyhoo_design_system/src/theme/colors/surface_colors.dart';
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'accent_colors.tailor.dart';

@immutable
@TailorMixinComponent()
class AccentColors extends ThemeExtension<AccentColors> with _$AccentColorsTailorMixin {
  const AccentColors({required this.primaryFixed, required this.onPrimaryFixed, required this.headline});

  @override
  final Color primaryFixed;
  @override
  final Color onPrimaryFixed;
  @override
  final Color headline;
}

/// Root ThemeTailor extension used by context.surface and context.accent
@immutable
@TailorMixin(themeGetter: ThemeGetter.onBuildContextProps)
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  const AppColors({required this.surface, required this.accent});

  @override
  final SurfaceColors surface;
  @override
  final AccentColors accent;
}
