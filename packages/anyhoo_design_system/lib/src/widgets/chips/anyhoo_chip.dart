import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

enum AnyhooChipVariant { primary, secondary, error, warning, inactive }

enum AnyhooChipShape { rounded, pill }

/// Compact Kinetic Logic chip / tag label.
class AnyhooChip extends StatelessWidget {
  factory AnyhooChip.filter({required String label, required bool selected, required VoidCallback onPressed}) {
    return AnyhooChip(
      label: label,
      leadingIcon: selected ? Icons.check : null,
      onPressed: onPressed,
      shape: AnyhooChipShape.pill,
      variant: selected ? AnyhooChipVariant.primary : AnyhooChipVariant.secondary,
    );
  }

  const AnyhooChip({
    super.key,
    required this.label,
    this.variant = AnyhooChipVariant.primary,
    this.shape = AnyhooChipShape.rounded,
    this.leadingIcon,
    this.onPressed,
    this.onDeleted,
  });

  final String label;
  final AnyhooChipVariant variant;
  final AnyhooChipShape shape;
  final IconData? leadingIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);
    final radius = shape == AnyhooChipShape.pill
        ? BorderRadius.circular(999)
        : BorderRadius.circular(DesignTokens.radiusMd);

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 14, color: colors.foreground),
          const SizedBox(width: DesignTokens.spacingXs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AnyhooTypography.label(LabelSize.medium).copyWith(color: colors.foreground),
          ),
        ),
        if (onDeleted != null) ...[
          const SizedBox(width: DesignTokens.spacingXs),
          GestureDetector(
            onTap: onDeleted,
            behavior: HitTestBehavior.opaque,
            child: Icon(Icons.close, size: 14, color: colors.foreground),
          ),
        ],
      ],
    );

    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: radius,
        border: colors.borderColor == null ? null : Border.all(color: colors.borderColor!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingXs),
        child: child,
      ),
    );

    if (onPressed == null) return chip;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(onTap: onPressed, borderRadius: radius, child: chip),
    );
  }

  _ChipColors _colors(BuildContext context) {
    final colors = context.controls.chipColors;

    return switch (variant) {
      AnyhooChipVariant.primary => _ChipColors(
        background: colors.primary.background,
        foreground: colors.primary.foreground,
        borderColor: colors.primary.borderColor,
      ),
      AnyhooChipVariant.secondary => _ChipColors(
        background: colors.secondary.background,
        foreground: colors.secondary.foreground,
        borderColor: colors.secondary.borderColor,
      ),
      AnyhooChipVariant.warning => _ChipColors(
        background: colors.warning.background,
        foreground: colors.warning.foreground,
        borderColor: colors.warning.borderColor,
      ),
      AnyhooChipVariant.error => _ChipColors(
        background: colors.error.background,
        foreground: colors.error.foreground,
        borderColor: colors.error.borderColor,
      ),
      AnyhooChipVariant.inactive => _ChipColors(
        background: colors.inactive.background,
        foreground: colors.inactive.foreground,
        borderColor: colors.inactive.borderColor,
      ),
    };
  }
}

class _ChipColors {
  const _ChipColors({required this.background, required this.foreground, this.borderColor});

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
