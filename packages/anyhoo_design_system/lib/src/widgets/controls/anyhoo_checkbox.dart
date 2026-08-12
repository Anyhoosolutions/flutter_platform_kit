import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic checkbox with an optional label.
class AnyhooCheckbox extends StatelessWidget {
  const AnyhooCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  static const _boxSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;
    final enabled = onChanged != null;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        color: value ? accent.primaryFixed : Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        border: Border.all(
          color: value ? accent.primaryFixed : surface.cardBorder,
          width: 2,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: 16, color: accent.onPrimaryFixed)
          : null,
    );

    final content = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Semantics(
        label: label,
        checked: value,
        child: GestureDetector(
          onTap: enabled ? () => onChanged!(!value) : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisSize: label == null ? MainAxisSize.min : MainAxisSize.max,
              children: [
                box,
                if (label != null) ...[
                  const SizedBox(width: DesignTokens.spacingMd),
                  Flexible(
                    child: Text(
                      label!,
                      style: AnyhooTypography.body(BodySize.large).copyWith(
                        color: surface.primaryText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return content;
  }
}
