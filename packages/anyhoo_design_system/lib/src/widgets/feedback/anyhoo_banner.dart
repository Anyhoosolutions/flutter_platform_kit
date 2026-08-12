import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Info / system banner with optional dismiss action.
class AnyhooBanner extends StatelessWidget {
  const AnyhooBanner({
    super.key,
    required this.title,
    required this.message,
    this.leadingIcon = Icons.info_outline,
    this.onDismiss,
  });

  final String title;
  final String message;
  final IconData leadingIcon;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface.secondaryContainer,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: surface.cardBorder.withValues(alpha: 0.3)),
        boxShadow: AnyhooCardShell.level1Shadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(leadingIcon, color: accent.primaryFixed, size: 24),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AnyhooTypography.label(LabelSize.large).copyWith(
                      color: surface.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Text(
                    message,
                    style: AnyhooTypography.body(BodySize.medium).copyWith(
                      color: surface.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: surface.secondaryText, size: 20),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
          ],
        ),
      ),
    );
  }
}
