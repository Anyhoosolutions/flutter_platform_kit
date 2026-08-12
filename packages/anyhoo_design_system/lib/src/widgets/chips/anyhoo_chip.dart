import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

enum AnyhooChipVariant { primary, error, surface, secondary, neutral, alert }

enum AnyhooChipShape { rounded, pill }

/// Compact Kinetic Logic chip / tag label.
class AnyhooChip extends StatelessWidget {
  const AnyhooChip({
    super.key,
    required this.label,
    this.variant = AnyhooChipVariant.primary,
    this.shape = AnyhooChipShape.rounded,
    this.leadingIcon,
    this.onTap,
    this.onDeleted,
  });

  final String label;
  final AnyhooChipVariant variant;
  final AnyhooChipShape shape;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
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
            style: AnyhooTypography.label(LabelSize.medium).copyWith(
              color: colors.foreground,
            ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm,
          vertical: DesignTokens.spacingXs,
        ),
        child: child,
      ),
    );

    if (onTap == null) return chip;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: chip,
      ),
    );
  }

  _ChipColors _colors(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;
    final status = context.status;

    return switch (variant) {
      AnyhooChipVariant.primary => _ChipColors(
        background: accent.primaryContainer.withValues(alpha: 0.2),
        foreground: accent.primaryFixed,
      ),
      AnyhooChipVariant.error => _ChipColors(
        background: DesignTokens.errorRed.withValues(alpha: 0.1),
        foreground: status.error,
        borderColor: DesignTokens.errorRed.withValues(alpha: 0.2),
      ),
      AnyhooChipVariant.surface => _ChipColors(
        background: surface.containerHigh,
        foreground: surface.secondaryText,
      ),
      AnyhooChipVariant.secondary => _ChipColors(
        background: surface.secondaryContainer,
        foreground: surface.onSecondaryContainer,
      ),
      AnyhooChipVariant.neutral => _ChipColors(
        background: surface.containerHighest,
        foreground: surface.secondaryText,
      ),
      AnyhooChipVariant.alert => _ChipColors(
        background: status.errorContainer,
        foreground: status.error,
      ),
    };
  }
}

class _ChipColors {
  const _ChipColors({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
