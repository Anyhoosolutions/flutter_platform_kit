// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surface_colors.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$SurfaceColorsTailorMixin on ThemeExtension<SurfaceColors> {
  Color get scaffoldBackground;
  Color get primaryText;
  Color get secondaryText;
  Color get cardBackground;
  Color get cardBorder;
  Color get outline;

  @override
  SurfaceColors copyWith({
    Color? scaffoldBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? cardBackground,
    Color? cardBorder,
    Color? outline,
  }) {
    return SurfaceColors(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      outline: outline ?? this.outline,
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
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
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
            const DeepCollectionEquality().equals(outline, other.outline));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(scaffoldBackground),
      const DeepCollectionEquality().hash(primaryText),
      const DeepCollectionEquality().hash(secondaryText),
      const DeepCollectionEquality().hash(cardBackground),
      const DeepCollectionEquality().hash(cardBorder),
      const DeepCollectionEquality().hash(outline),
    );
  }
}
