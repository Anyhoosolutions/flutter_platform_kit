import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic toggle switch with an optional leading label.
class AnyhooSwitch extends StatelessWidget {
  const AnyhooSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  static const _trackWidth = 44.0;
  static const _trackHeight = 24.0;
  static const _thumbSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;
    final enabled = onChanged != null;

    final control = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Semantics(
        label: label,
        toggled: value,
        child: GestureDetector(
          onTap: enabled ? () => onChanged!(!value) : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 48,
            child: Align(
              alignment: Alignment.centerRight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: _trackWidth,
                height: _trackHeight,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: value ? accent.primaryFixed : surface.cardBorder,
                  borderRadius: BorderRadius.circular(_trackHeight / 2),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: surface.cardBorder),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (label == null) return control;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label!,
              style: AnyhooTypography.body(BodySize.large).copyWith(color: surface.primaryText),
            ),
          ),
          control,
        ],
      ),
    );
  }
}
