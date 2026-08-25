// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_colors.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$SurfaceColorsTailorMixin on ThemeExtension<SurfaceColors> {
  Color get scaffoldBackground;
  Color get lowContrastBackground;
  Color get primaryText;
  Color get secondaryText;
  Color get cardBackground;
  Color get cardBorder;
  Color get containerHigh;
  Color get containerLow;
  Color get containerHighest;
  Color get containerLowest;
  Color get outline;
  Color get secondaryContainer;
  Color get onSecondaryContainer;
  Color get inverseSurface;
  Color get inverseOnSurface;

  @override
  SurfaceColors copyWith({
    Color? scaffoldBackground,
    Color? lowContrastBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? cardBackground,
    Color? cardBorder,
    Color? containerHigh,
    Color? containerLow,
    Color? containerHighest,
    Color? containerLowest,
    Color? outline,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? inverseSurface,
    Color? inverseOnSurface,
  }) {
    return SurfaceColors(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      lowContrastBackground:
          lowContrastBackground ?? this.lowContrastBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      containerHigh: containerHigh ?? this.containerHigh,
      containerLow: containerLow ?? this.containerLow,
      containerHighest: containerHighest ?? this.containerHighest,
      containerLowest: containerLowest ?? this.containerLowest,
      outline: outline ?? this.outline,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
    );
  }

  @override
  SurfaceColors lerp(covariant ThemeExtension<SurfaceColors>? other, double t) {
    if (other is! SurfaceColors) return this as SurfaceColors;
    return SurfaceColors(
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      lowContrastBackground: Color.lerp(
        lowContrastBackground,
        other.lowContrastBackground,
        t,
      )!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      containerHigh: Color.lerp(containerHigh, other.containerHigh, t)!,
      containerLow: Color.lerp(containerLow, other.containerLow, t)!,
      containerHighest: Color.lerp(
        containerHighest,
        other.containerHighest,
        t,
      )!,
      containerLowest: Color.lerp(containerLowest, other.containerLowest, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      )!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inverseOnSurface: Color.lerp(
        inverseOnSurface,
        other.inverseOnSurface,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SurfaceColors &&
            const DeepCollectionEquality().equals(
              scaffoldBackground,
              other.scaffoldBackground,
            ) &&
            const DeepCollectionEquality().equals(
              lowContrastBackground,
              other.lowContrastBackground,
            ) &&
            const DeepCollectionEquality().equals(
              primaryText,
              other.primaryText,
            ) &&
            const DeepCollectionEquality().equals(
              secondaryText,
              other.secondaryText,
            ) &&
            const DeepCollectionEquality().equals(
              cardBackground,
              other.cardBackground,
            ) &&
            const DeepCollectionEquality().equals(
              cardBorder,
              other.cardBorder,
            ) &&
            const DeepCollectionEquality().equals(
              containerHigh,
              other.containerHigh,
            ) &&
            const DeepCollectionEquality().equals(
              containerLow,
              other.containerLow,
            ) &&
            const DeepCollectionEquality().equals(
              containerHighest,
              other.containerHighest,
            ) &&
            const DeepCollectionEquality().equals(
              containerLowest,
              other.containerLowest,
            ) &&
            const DeepCollectionEquality().equals(outline, other.outline) &&
            const DeepCollectionEquality().equals(
              secondaryContainer,
              other.secondaryContainer,
            ) &&
            const DeepCollectionEquality().equals(
              onSecondaryContainer,
              other.onSecondaryContainer,
            ) &&
            const DeepCollectionEquality().equals(
              inverseSurface,
              other.inverseSurface,
            ) &&
            const DeepCollectionEquality().equals(
              inverseOnSurface,
              other.inverseOnSurface,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(scaffoldBackground),
      const DeepCollectionEquality().hash(lowContrastBackground),
      const DeepCollectionEquality().hash(primaryText),
      const DeepCollectionEquality().hash(secondaryText),
      const DeepCollectionEquality().hash(cardBackground),
      const DeepCollectionEquality().hash(cardBorder),
      const DeepCollectionEquality().hash(containerHigh),
      const DeepCollectionEquality().hash(containerLow),
      const DeepCollectionEquality().hash(containerHighest),
      const DeepCollectionEquality().hash(containerLowest),
      const DeepCollectionEquality().hash(outline),
      const DeepCollectionEquality().hash(secondaryContainer),
      const DeepCollectionEquality().hash(onSecondaryContainer),
      const DeepCollectionEquality().hash(inverseSurface),
      const DeepCollectionEquality().hash(inverseOnSurface),
    );
  }
}

mixin _$AppBarColorsTailorMixin on ThemeExtension<AppBarColors> {
  Color get topBarBackground;
  Color get topBarBorder;
  Color get topBarText;
  Color get backButtonColor;
  Color get iconColor;
  Color get bottomBarBackground;
  Color get bottomBarIconColors;

  @override
  AppBarColors copyWith({
    Color? topBarBackground,
    Color? topBarBorder,
    Color? topBarText,
    Color? backButtonColor,
    Color? iconColor,
    Color? bottomBarBackground,
    Color? bottomBarIconColors,
  }) {
    return AppBarColors(
      topBarBackground: topBarBackground ?? this.topBarBackground,
      topBarBorder: topBarBorder ?? this.topBarBorder,
      topBarText: topBarText ?? this.topBarText,
      backButtonColor: backButtonColor ?? this.backButtonColor,
      iconColor: iconColor ?? this.iconColor,
      bottomBarBackground: bottomBarBackground ?? this.bottomBarBackground,
      bottomBarIconColors: bottomBarIconColors ?? this.bottomBarIconColors,
    );
  }

  @override
  AppBarColors lerp(covariant ThemeExtension<AppBarColors>? other, double t) {
    if (other is! AppBarColors) return this as AppBarColors;
    return AppBarColors(
      topBarBackground: Color.lerp(
        topBarBackground,
        other.topBarBackground,
        t,
      )!,
      topBarBorder: Color.lerp(topBarBorder, other.topBarBorder, t)!,
      topBarText: Color.lerp(topBarText, other.topBarText, t)!,
      backButtonColor: Color.lerp(backButtonColor, other.backButtonColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      bottomBarBackground: Color.lerp(
        bottomBarBackground,
        other.bottomBarBackground,
        t,
      )!,
      bottomBarIconColors: Color.lerp(
        bottomBarIconColors,
        other.bottomBarIconColors,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppBarColors &&
            const DeepCollectionEquality().equals(
              topBarBackground,
              other.topBarBackground,
            ) &&
            const DeepCollectionEquality().equals(
              topBarBorder,
              other.topBarBorder,
            ) &&
            const DeepCollectionEquality().equals(
              topBarText,
              other.topBarText,
            ) &&
            const DeepCollectionEquality().equals(
              backButtonColor,
              other.backButtonColor,
            ) &&
            const DeepCollectionEquality().equals(iconColor, other.iconColor) &&
            const DeepCollectionEquality().equals(
              bottomBarBackground,
              other.bottomBarBackground,
            ) &&
            const DeepCollectionEquality().equals(
              bottomBarIconColors,
              other.bottomBarIconColors,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(topBarBackground),
      const DeepCollectionEquality().hash(topBarBorder),
      const DeepCollectionEquality().hash(topBarText),
      const DeepCollectionEquality().hash(backButtonColor),
      const DeepCollectionEquality().hash(iconColor),
      const DeepCollectionEquality().hash(bottomBarBackground),
      const DeepCollectionEquality().hash(bottomBarIconColors),
    );
  }
}

mixin _$AccentColorsTailorMixin on ThemeExtension<AccentColors> {
  Color get primaryFixed;
  Color get onPrimaryFixed;
  Color get primaryDisabled;
  Color get onPrimaryDisabled;
  Color get primaryContainer;
  Color get onPrimaryContainer;
  Color get headline;
  Color get inversePrimary;

  @override
  AccentColors copyWith({
    Color? primaryFixed,
    Color? onPrimaryFixed,
    Color? primaryDisabled,
    Color? onPrimaryDisabled,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? headline,
    Color? inversePrimary,
  }) {
    return AccentColors(
      primaryFixed: primaryFixed ?? this.primaryFixed,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      onPrimaryDisabled: onPrimaryDisabled ?? this.onPrimaryDisabled,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      headline: headline ?? this.headline,
      inversePrimary: inversePrimary ?? this.inversePrimary,
    );
  }

  @override
  AccentColors lerp(covariant ThemeExtension<AccentColors>? other, double t) {
    if (other is! AccentColors) return this as AccentColors;
    return AccentColors(
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      onPrimaryDisabled: Color.lerp(
        onPrimaryDisabled,
        other.onPrimaryDisabled,
        t,
      )!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      headline: Color.lerp(headline, other.headline, t)!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccentColors &&
            const DeepCollectionEquality().equals(
              primaryFixed,
              other.primaryFixed,
            ) &&
            const DeepCollectionEquality().equals(
              onPrimaryFixed,
              other.onPrimaryFixed,
            ) &&
            const DeepCollectionEquality().equals(
              primaryDisabled,
              other.primaryDisabled,
            ) &&
            const DeepCollectionEquality().equals(
              onPrimaryDisabled,
              other.onPrimaryDisabled,
            ) &&
            const DeepCollectionEquality().equals(
              primaryContainer,
              other.primaryContainer,
            ) &&
            const DeepCollectionEquality().equals(
              onPrimaryContainer,
              other.onPrimaryContainer,
            ) &&
            const DeepCollectionEquality().equals(headline, other.headline) &&
            const DeepCollectionEquality().equals(
              inversePrimary,
              other.inversePrimary,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(primaryFixed),
      const DeepCollectionEquality().hash(onPrimaryFixed),
      const DeepCollectionEquality().hash(primaryDisabled),
      const DeepCollectionEquality().hash(onPrimaryDisabled),
      const DeepCollectionEquality().hash(primaryContainer),
      const DeepCollectionEquality().hash(onPrimaryContainer),
      const DeepCollectionEquality().hash(headline),
      const DeepCollectionEquality().hash(inversePrimary),
    );
  }
}

mixin _$StatusColorsTailorMixin on ThemeExtension<StatusColors> {
  Color get error;
  Color get errorContainer;
  Color get warning;
  Color get success;

  @override
  StatusColors copyWith({
    Color? error,
    Color? errorContainer,
    Color? warning,
    Color? success,
  }) {
    return StatusColors(
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      warning: warning ?? this.warning,
      success: success ?? this.success,
    );
  }

  @override
  StatusColors lerp(covariant ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this as StatusColors;
    return StatusColors(
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatusColors &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(
              errorContainer,
              other.errorContainer,
            ) &&
            const DeepCollectionEquality().equals(warning, other.warning) &&
            const DeepCollectionEquality().equals(success, other.success));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(errorContainer),
      const DeepCollectionEquality().hash(warning),
      const DeepCollectionEquality().hash(success),
    );
  }
}

mixin _$ShimmerColorsTailorMixin on ThemeExtension<ShimmerColors> {
  Color get baseColor;
  Color get highlightColor;

  @override
  ShimmerColors copyWith({Color? baseColor, Color? highlightColor}) {
    return ShimmerColors(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ShimmerColors lerp(covariant ThemeExtension<ShimmerColors>? other, double t) {
    if (other is! ShimmerColors) return this as ShimmerColors;
    return ShimmerColors(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShimmerColors &&
            const DeepCollectionEquality().equals(baseColor, other.baseColor) &&
            const DeepCollectionEquality().equals(
              highlightColor,
              other.highlightColor,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(baseColor),
      const DeepCollectionEquality().hash(highlightColor),
    );
  }
}

mixin _$AppColorsTailorMixin on ThemeExtension<AppColors> {
  SurfaceColors get surface;
  AccentColors get accent;
  StatusColors get status;
  ShimmerColors get shimmer;
  AppBarColors get appBar;

  @override
  AppColors copyWith({
    SurfaceColors? surface,
    AccentColors? accent,
    StatusColors? status,
    ShimmerColors? shimmer,
    AppBarColors? appBar,
  }) {
    return AppColors(
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
      status: status ?? this.status,
      shimmer: shimmer ?? this.shimmer,
      appBar: appBar ?? this.appBar,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this as AppColors;
    return AppColors(
      surface: surface.lerp(other.surface, t),
      accent: accent.lerp(other.accent, t),
      status: status.lerp(other.status, t),
      shimmer: shimmer.lerp(other.shimmer, t),
      appBar: appBar.lerp(other.appBar, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppColors &&
            const DeepCollectionEquality().equals(surface, other.surface) &&
            const DeepCollectionEquality().equals(accent, other.accent) &&
            const DeepCollectionEquality().equals(status, other.status) &&
            const DeepCollectionEquality().equals(shimmer, other.shimmer) &&
            const DeepCollectionEquality().equals(appBar, other.appBar));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(surface),
      const DeepCollectionEquality().hash(accent),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(shimmer),
      const DeepCollectionEquality().hash(appBar),
    );
  }
}

extension AppColorsBuildContextProps on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  SurfaceColors get surface => appColors.surface;
  AccentColors get accent => appColors.accent;
  StatusColors get status => appColors.status;
  ShimmerColors get shimmer => appColors.shimmer;
  AppBarColors get appBar => appColors.appBar;
}
