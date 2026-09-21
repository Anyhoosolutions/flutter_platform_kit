import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'controls_colors.tailor.dart';

@TailorMixin()
class ControlsColors extends ThemeExtension<ControlsColors> with _$ControlsColorsTailorMixin {
  const ControlsColors({
    required this.switchColors,
    required this.cardColors,
    required this.segmentColors,
    required this.avatarColors,
    required this.chipColors,
  });

  @override
  final AnyhooSwitchColors switchColors;
  @override
  final ColorSet cardColors;
  @override
  final SegmentColors segmentColors;
  @override
  final AvatarColors avatarColors;
  @override
  final ChipColors chipColors;
}

@TailorMixin()
class ColorSet extends ThemeExtension<ColorSet> with _$ColorSetTailorMixin {
  const ColorSet({required this.background, required this.foreground, required this.borderColor});

  @override
  final Color background;
  @override
  final Color foreground;
  @override
  final Color? borderColor;
}

@TailorMixin()
class AnyhooSwitchColors extends ThemeExtension<AnyhooSwitchColors> with _$AnyhooSwitchColorsTailorMixin {
  const AnyhooSwitchColors({required this.background, required this.button});

  @override
  final Color background;
  @override
  final Color button;
}

@TailorMixin()
class SegmentColors extends ThemeExtension<SegmentColors> with _$SegmentColorsTailorMixin {
  const SegmentColors({required this.regular, required this.selected});

  @override
  final ColorSet regular;
  @override
  final ColorSet selected;
}

@TailorMixin()
class ChipColors extends ThemeExtension<ChipColors> with _$ChipColorsTailorMixin {
  const ChipColors({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.warning,
    required this.inactive,
  });

  @override
  final ColorSet primary;
  @override
  final ColorSet secondary;
  @override
  final ColorSet error;
  @override
  final ColorSet warning;
  @override
  final ColorSet inactive;
}

@TailorMixin()
class AvatarColors extends ThemeExtension<AvatarColors> with _$AvatarColorsTailorMixin {
  const AvatarColors({required this.regular, required this.selected});

  @override
  final ColorSet regular;
  @override
  final ColorSet selected;
}
