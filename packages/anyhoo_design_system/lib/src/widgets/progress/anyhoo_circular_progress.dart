import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic circular progress indicator.
class AnyhooCircularProgress extends StatelessWidget {
  const AnyhooCircularProgress({
    super.key,
    this.value,
    this.size = 32,
    this.strokeWidth = 3,
  });

  /// Progress from 0–1. When null, shows an indeterminate spinner.
  final double? value;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        color: accent.primaryFixed,
        backgroundColor: surface.containerHighest,
      ),
    );
  }
}
