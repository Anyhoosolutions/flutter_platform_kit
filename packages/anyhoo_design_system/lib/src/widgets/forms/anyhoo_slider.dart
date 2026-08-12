import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Themed Kinetic Logic slider with optional leading/trailing icons.
class AnyhooSlider extends StatelessWidget {
  const AnyhooSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.leadingIcon,
    this.trailingIcon,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    final slider = SliderTheme(
      data: SliderThemeData(
        activeTrackColor: accent.primaryFixed,
        inactiveTrackColor: surface.containerHigh,
        thumbColor: Colors.white,
        overlayColor: accent.primaryFixed.withValues(alpha: 0.12),
        trackHeight: 4,
        thumbShape: const _BorderedThumbShape(),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );

    if (leadingIcon == null && trailingIcon == null) return slider;

    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20, color: surface.secondaryText),
          const SizedBox(width: DesignTokens.spacingXs),
        ],
        Expanded(child: slider),
        if (trailingIcon != null) ...[
          const SizedBox(width: DesignTokens.spacingXs),
          Icon(trailingIcon, size: 20, color: surface.secondaryText),
        ],
      ],
    );
  }
}

class _BorderedThumbShape extends SliderComponentShape {
  const _BorderedThumbShape();

  static const _radius = 10.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final primary = sliderTheme.activeTrackColor ?? DesignTokens.primary;

    canvas.drawCircle(center, _radius, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
}
