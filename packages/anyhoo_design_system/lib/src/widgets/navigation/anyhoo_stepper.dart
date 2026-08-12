import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Horizontal step indicator with completed / active / pending states.
class AnyhooStepper extends StatelessWidget {
  const AnyhooStepper({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;

  /// Zero-based index of the active step.
  final int currentStep;

  static const _circleSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 20),
                color: i <= currentStep
                    ? accent.primaryFixed
                    : surface.cardBorder,
              ),
            ),
          _StepNode(
            label: steps[i],
            index: i,
            currentStep: currentStep,
            circleSize: _circleSize,
          ),
        ],
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.label,
    required this.index,
    required this.currentStep,
    required this.circleSize,
  });

  final String label;
  final int index;
  final int currentStep;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    final completed = index < currentStep;
    final active = index == currentStep;

    final Color borderColor;
    final Color? fillColor;
    final Color labelColor;

    if (completed) {
      borderColor = accent.primaryFixed;
      fillColor = accent.primaryFixed;
      labelColor = surface.primaryText;
    } else if (active) {
      borderColor = accent.primaryFixed;
      fillColor = null;
      labelColor = surface.primaryText;
    } else {
      borderColor = surface.cardBorder;
      fillColor = null;
      labelColor = surface.secondaryText;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.center,
          child: completed
              ? Icon(Icons.check, size: 16, color: accent.onPrimaryFixed)
              : Text(
                  '${index + 1}',
                  style: AnyhooTypography.label(LabelSize.medium).copyWith(
                    color: active ? accent.primaryFixed : surface.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          label,
          style: AnyhooTypography.label(LabelSize.medium).copyWith(
            color: labelColor,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
