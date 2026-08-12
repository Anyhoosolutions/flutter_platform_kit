import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Selectable filter chip with check icon when selected.
class AnyhooFilterChip extends StatelessWidget {
  const AnyhooFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    final borderColor = selected ? accent.primaryFixed : surface.outline;
    final background = selected
        ? accent.primaryFixed.withValues(alpha: 0.05)
        : Colors.transparent;
    final foreground = selected ? accent.primaryFixed : surface.secondaryText;

    final radius = BorderRadius.circular(999);

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selected) ...[
          Icon(Icons.check, size: 14, color: foreground),
          const SizedBox(width: DesignTokens.spacingXs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AnyhooTypography.label(LabelSize.medium).copyWith(
              color: foreground,
            ),
          ),
        ),
      ],
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onSelected(!selected),
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
