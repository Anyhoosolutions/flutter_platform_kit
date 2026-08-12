import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@immutable
@TailorMixinComponent()
class SurfaceColors extends ThemeExtension<SurfaceColors> with _$SurfaceColorsTailorMixin {
  const SurfaceColors({
    required this.scaffoldBackground,
    required this.lowContrastBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBackground,
    required this.cardBorder,
    required this.containerHigh,
    required this.containerLow,
    required this.containerHighest,
    required this.containerLowest,
    required this.outline,
    required this.topBarBackground,
    required this.topBarText,
    required this.bottomBarBackground,
    required this.bottomBarIconColors,
  });

  @override
  final Color scaffoldBackground;
  @override
  final Color lowContrastBackground;
  @override
  final Color primaryText;
  @override
  final Color secondaryText;
  @override
  final Color cardBackground;
  @override
  final Color cardBorder;
  @override
  final Color containerHigh;
  @override
  final Color containerLow;
  @override
  final Color containerHighest;
  @override
  final Color containerLowest;
  @override
  final Color outline;
  @override
  final Color topBarBackground;
  @override
  final Color topBarText;

  @override
  final Color bottomBarBackground;
  @override
  final Color bottomBarIconColors;
}

@immutable
@TailorMixinComponent()
class AppBarColors extends ThemeExtension<AppBarColors> with _$AppBarColorsTailorMixin {
  const AppBarColors({
    required this.topBarBackground,
    required this.topBarBorder,
    required this.topBarText,
    required this.backButtonColor,
    required this.iconColor,
    required this.bottomBarBackground,
    required this.bottomBarIconColors,
  });

  @override
  final Color topBarBackground;
  @override
  final Color topBarBorder;
  @override
  final Color topBarText;
  @override
  final Color backButtonColor;
  @override
  final Color iconColor;

  @override
  final Color bottomBarBackground;
  @override
  final Color bottomBarIconColors;
}

@immutable
@TailorMixinComponent()
class AccentColors extends ThemeExtension<AccentColors> with _$AccentColorsTailorMixin {
  const AccentColors({
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryDisabled,
    required this.onPrimaryDisabled,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.headline,
  });

  @override
  final Color primaryFixed;
  @override
  final Color onPrimaryFixed;
  @override
  final Color primaryDisabled;
  @override
  final Color onPrimaryDisabled;
  @override
  final Color primaryContainer;
  @override
  final Color onPrimaryContainer;
  @override
  final Color headline;
}

@immutable
@TailorMixinComponent()
class StatusColors extends ThemeExtension<StatusColors> with _$StatusColorsTailorMixin {
  const StatusColors({required this.error, required this.errorContainer, required this.warning, required this.success});

  @override
  final Color error;
  @override
  final Color errorContainer;
  @override
  final Color warning;
  @override
  final Color success;
}

@immutable
@TailorMixinComponent()
class ShimmerColors extends ThemeExtension<ShimmerColors> with _$ShimmerColorsTailorMixin {
  const ShimmerColors({required this.baseColor, required this.highlightColor});

  @override
  final Color baseColor;
  @override
  final Color highlightColor;
}

/// Root ThemeTailor extension used across all Anyhoo apps.
/// Automatically generates BuildContext extensions (e.g. context.surface, context.accent).
@immutable
@TailorMixin(themeGetter: ThemeGetter.onBuildContextProps)
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  const AppColors({
    required this.surface,
    required this.accent,
    required this.status,
    required this.shimmer,
    required this.appBar,
  });

  @override
  final SurfaceColors surface;
  @override
  final AccentColors accent;
  @override
  final StatusColors status;
  @override
  final ShimmerColors shimmer;
  @override
  final AppBarColors appBar;
}
