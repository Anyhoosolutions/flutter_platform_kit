import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic radio button with an optional label.
class AnyhooRadio<T> extends StatelessWidget {
  const AnyhooRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;

  static const _outerSize = 20.0;
  static const _innerSize = 10.0;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;
    final enabled = onChanged != null;

    final indicator = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _outerSize,
      height: _outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _selected ? accent.primaryFixed : surface.cardBorder,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _selected ? 1 : 0,
        child: Container(
          width: _innerSize,
          height: _innerSize,
          decoration: BoxDecoration(
            color: accent.primaryFixed,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Semantics(
        label: label,
        checked: _selected,
        inMutuallyExclusiveGroup: true,
        child: GestureDetector(
          onTap: enabled ? () => onChanged!(value) : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisSize: label == null ? MainAxisSize.min : MainAxisSize.max,
              children: [
                indicator,
                if (label != null) ...[
                  const SizedBox(width: DesignTokens.spacingMd),
                  Flexible(
                    child: Text(
                      label!,
                      style: AnyhooTypography.body(BodySize.large).copyWith(
                        color: _selected ? surface.primaryText : surface.secondaryText,
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
  }
}
