// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controls_colors.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$ControlsColorsTailorMixin on ThemeExtension<ControlsColors> {
  AnyhooSwitchColors get switchColors;
  ColorSet get cardColors;
  SegmentColors get segmentColors;
  AvatarColors get avatarColors;
  ChipColors get chipColors;

  @override
  ControlsColors copyWith({
    AnyhooSwitchColors? switchColors,
    ColorSet? cardColors,
    SegmentColors? segmentColors,
    AvatarColors? avatarColors,
    ChipColors? chipColors,
  }) {
    return ControlsColors(
      switchColors: switchColors ?? this.switchColors,
      cardColors: cardColors ?? this.cardColors,
      segmentColors: segmentColors ?? this.segmentColors,
      avatarColors: avatarColors ?? this.avatarColors,
      chipColors: chipColors ?? this.chipColors,
    );
  }

  @override
  ControlsColors lerp(
    covariant ThemeExtension<ControlsColors>? other,
    double t,
  ) {
    if (other is! ControlsColors) return this as ControlsColors;
    return ControlsColors(
      switchColors: switchColors.lerp(other.switchColors, t),
      cardColors: cardColors.lerp(other.cardColors, t),
      segmentColors: segmentColors.lerp(other.segmentColors, t),
      avatarColors: avatarColors.lerp(other.avatarColors, t),
      chipColors: chipColors.lerp(other.chipColors, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ControlsColors &&
            const DeepCollectionEquality().equals(
              switchColors,
              other.switchColors,
            ) &&
            const DeepCollectionEquality().equals(
              cardColors,
              other.cardColors,
            ) &&
            const DeepCollectionEquality().equals(
              segmentColors,
              other.segmentColors,
            ) &&
            const DeepCollectionEquality().equals(
              avatarColors,
              other.avatarColors,
            ) &&
            const DeepCollectionEquality().equals(
              chipColors,
              other.chipColors,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(switchColors),
      const DeepCollectionEquality().hash(cardColors),
      const DeepCollectionEquality().hash(segmentColors),
      const DeepCollectionEquality().hash(avatarColors),
      const DeepCollectionEquality().hash(chipColors),
    );
  }
}

extension ControlsColorsBuildContextProps on BuildContext {
  ControlsColors get controlsColors =>
      Theme.of(this).extension<ControlsColors>()!;
  AnyhooSwitchColors get switchColors => controlsColors.switchColors;
  ColorSet get cardColors => controlsColors.cardColors;
  SegmentColors get segmentColors => controlsColors.segmentColors;
  AvatarColors get avatarColors => controlsColors.avatarColors;
  ChipColors get chipColors => controlsColors.chipColors;
}

mixin _$ColorSetTailorMixin on ThemeExtension<ColorSet> {
  Color get background;
  Color get foreground;
  Color? get borderColor;

  @override
  ColorSet copyWith({
    Color? background,
    Color? foreground,
    Color? borderColor,
  }) {
    return ColorSet(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ColorSet lerp(covariant ThemeExtension<ColorSet>? other, double t) {
    if (other is! ColorSet) return this as ColorSet;
    return ColorSet(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ColorSet &&
            const DeepCollectionEquality().equals(
              background,
              other.background,
            ) &&
            const DeepCollectionEquality().equals(
              foreground,
              other.foreground,
            ) &&
            const DeepCollectionEquality().equals(
              borderColor,
              other.borderColor,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(foreground),
      const DeepCollectionEquality().hash(borderColor),
    );
  }
}

extension ColorSetBuildContextProps on BuildContext {
  ColorSet get colorSet => Theme.of(this).extension<ColorSet>()!;
  Color get background => colorSet.background;
  Color get foreground => colorSet.foreground;
  Color? get borderColor => colorSet.borderColor;
}

mixin _$AnyhooSwitchColorsTailorMixin on ThemeExtension<AnyhooSwitchColors> {
  Color get background;
  Color get button;

  @override
  AnyhooSwitchColors copyWith({Color? background, Color? button}) {
    return AnyhooSwitchColors(
      background: background ?? this.background,
      button: button ?? this.button,
    );
  }

  @override
  AnyhooSwitchColors lerp(
    covariant ThemeExtension<AnyhooSwitchColors>? other,
    double t,
  ) {
    if (other is! AnyhooSwitchColors) return this as AnyhooSwitchColors;
    return AnyhooSwitchColors(
      background: Color.lerp(background, other.background, t)!,
      button: Color.lerp(button, other.button, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnyhooSwitchColors &&
            const DeepCollectionEquality().equals(
              background,
              other.background,
            ) &&
            const DeepCollectionEquality().equals(button, other.button));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(button),
    );
  }
}

extension AnyhooSwitchColorsBuildContextProps on BuildContext {
  AnyhooSwitchColors get anyhooSwitchColors =>
      Theme.of(this).extension<AnyhooSwitchColors>()!;
  Color get background => anyhooSwitchColors.background;
  Color get button => anyhooSwitchColors.button;
}

mixin _$SegmentColorsTailorMixin on ThemeExtension<SegmentColors> {
  ColorSet get regular;
  ColorSet get selected;

  @override
  SegmentColors copyWith({ColorSet? regular, ColorSet? selected}) {
    return SegmentColors(
      regular: regular ?? this.regular,
      selected: selected ?? this.selected,
    );
  }

  @override
  SegmentColors lerp(covariant ThemeExtension<SegmentColors>? other, double t) {
    if (other is! SegmentColors) return this as SegmentColors;
    return SegmentColors(
      regular: regular.lerp(other.regular, t),
      selected: selected.lerp(other.selected, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SegmentColors &&
            const DeepCollectionEquality().equals(regular, other.regular) &&
            const DeepCollectionEquality().equals(selected, other.selected));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(regular),
      const DeepCollectionEquality().hash(selected),
    );
  }
}

extension SegmentColorsBuildContextProps on BuildContext {
  SegmentColors get segmentColors => Theme.of(this).extension<SegmentColors>()!;
  ColorSet get regular => segmentColors.regular;
  ColorSet get selected => segmentColors.selected;
}

mixin _$ChipColorsTailorMixin on ThemeExtension<ChipColors> {
  ColorSet get primary;
  ColorSet get secondary;
  ColorSet get error;
  ColorSet get warning;
  ColorSet get inactive;

  @override
  ChipColors copyWith({
    ColorSet? primary,
    ColorSet? secondary,
    ColorSet? error,
    ColorSet? warning,
    ColorSet? inactive,
  }) {
    return ChipColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      inactive: inactive ?? this.inactive,
    );
  }

  @override
  ChipColors lerp(covariant ThemeExtension<ChipColors>? other, double t) {
    if (other is! ChipColors) return this as ChipColors;
    return ChipColors(
      primary: primary.lerp(other.primary, t),
      secondary: secondary.lerp(other.secondary, t),
      error: error.lerp(other.error, t),
      warning: warning.lerp(other.warning, t),
      inactive: inactive.lerp(other.inactive, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChipColors &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary) &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(warning, other.warning) &&
            const DeepCollectionEquality().equals(inactive, other.inactive));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(secondary),
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(warning),
      const DeepCollectionEquality().hash(inactive),
    );
  }
}

extension ChipColorsBuildContextProps on BuildContext {
  ChipColors get chipColors => Theme.of(this).extension<ChipColors>()!;
  ColorSet get primary => chipColors.primary;
  ColorSet get secondary => chipColors.secondary;
  ColorSet get error => chipColors.error;
  ColorSet get warning => chipColors.warning;
  ColorSet get inactive => chipColors.inactive;
}

mixin _$AvatarColorsTailorMixin on ThemeExtension<AvatarColors> {
  ColorSet get regular;
  ColorSet get selected;

  @override
  AvatarColors copyWith({ColorSet? regular, ColorSet? selected}) {
    return AvatarColors(
      regular: regular ?? this.regular,
      selected: selected ?? this.selected,
    );
  }

  @override
  AvatarColors lerp(covariant ThemeExtension<AvatarColors>? other, double t) {
    if (other is! AvatarColors) return this as AvatarColors;
    return AvatarColors(
      regular: regular.lerp(other.regular, t),
      selected: selected.lerp(other.selected, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvatarColors &&
            const DeepCollectionEquality().equals(regular, other.regular) &&
            const DeepCollectionEquality().equals(selected, other.selected));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(regular),
      const DeepCollectionEquality().hash(selected),
    );
  }
}

extension AvatarColorsBuildContextProps on BuildContext {
  AvatarColors get avatarColors => Theme.of(this).extension<AvatarColors>()!;
  ColorSet get regular => avatarColors.regular;
  ColorSet get selected => avatarColors.selected;
}
