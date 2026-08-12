import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic linear progress bar.
class AnyhooLinearProgress extends StatelessWidget {
  const AnyhooLinearProgress({
    super.key,
    this.value,
    this.height = 8,
  });

  /// Progress from 0–1. When null, shows an indeterminate bar.
  final double? value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value,
          minHeight: height,
          color: accent.primaryFixed,
          backgroundColor: surface.containerHighest,
        ),
      ),
    );
  }
}
