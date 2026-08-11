// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accent_colors.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AccentColorsTailorMixin on ThemeExtension<AccentColors> {
  Color get primaryFixed;
  Color get onPrimaryFixed;
  Color get headline;

  @override
  AccentColors copyWith({
    Color? primaryFixed,
    Color? onPrimaryFixed,
    Color? headline,
  }) {
    return AccentColors(
      primaryFixed: primaryFixed ?? this.primaryFixed,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      headline: headline ?? this.headline,
    );
  }

  @override
  AccentColors lerp(covariant ThemeExtension<AccentColors>? other, double t) {
    if (other is! AccentColors) return this as AccentColors;
    return AccentColors(
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      headline: Color.lerp(headline, other.headline, t)!,
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
            const DeepCollectionEquality().equals(headline, other.headline));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(primaryFixed),
      const DeepCollectionEquality().hash(onPrimaryFixed),
      const DeepCollectionEquality().hash(headline),
    );
  }
}

mixin _$AppColorsTailorMixin on ThemeExtension<AppColors> {
  SurfaceColors get surface;
  AccentColors get accent;

  @override
  AppColors copyWith({SurfaceColors? surface, AccentColors? accent}) {
    return AppColors(
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this as AppColors;
    return AppColors(
      surface: surface.lerp(other.surface, t),
      accent: accent.lerp(other.accent, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppColors &&
            const DeepCollectionEquality().equals(surface, other.surface) &&
            const DeepCollectionEquality().equals(accent, other.accent));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(surface),
      const DeepCollectionEquality().hash(accent),
    );
  }
}

extension AppColorsBuildContextProps on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  SurfaceColors get surface => appColors.surface;
  AccentColors get accent => appColors.accent;
}
