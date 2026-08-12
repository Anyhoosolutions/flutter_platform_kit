import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Single settings-style row: leading icon, title/subtitle, optional chevron.
class AnyhooListItem extends StatelessWidget {
  const AnyhooListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingBackground,
    this.leadingCircular = false,
    this.onTap,
    this.showChevron = true,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;

  /// When set, wraps [leadingIcon] in a padded rounded-lg background box.
  /// Icon color defaults to primary when this is non-null.
  final Color? leadingBackground;

  /// When true with [leadingBackground], uses a circular leading container.
  final bool leadingCircular;
  final VoidCallback? onTap;
  final bool showChevron;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                if (leadingBackground != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: leadingBackground,
                      shape: leadingCircular ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: leadingCircular
                          ? null
                          : BorderRadius.circular(DesignTokens.radiusMd),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(DesignTokens.spacingSm),
                      child: Icon(
                        leadingIcon,
                        color: accent.primaryFixed,
                        size: 24,
                      ),
                    ),
                  )
                else
                  Icon(leadingIcon, color: surface.secondaryText, size: 24),
                const SizedBox(width: DesignTokens.spacingMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AnyhooTypography.label(LabelSize.large).copyWith(
                        color: surface.primaryText,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AnyhooTypography.body(BodySize.medium).copyWith(
                          color: surface.secondaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showChevron)
                Icon(Icons.chevron_right, color: surface.outline, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
