import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Simple elevated card with title, body, and an optional text action.
class AnyhooStandardCard extends StatelessWidget {
  const AnyhooStandardCard({
    super.key,
    this.prefixIcon,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  final IconData? prefixIcon;
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final showAction = actionLabel != null && onAction != null;

    return AnyhooCardShell(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon!, color: accent.primaryFixed),
                const SizedBox(width: DesignTokens.spacingSm),
              ],
              Text(
                title,
                style: AppFonts.inter.copyWith(
                  fontSize: 20,
                  height: 28 / 20,
                  fontWeight: FontWeight.w600,
                  color: surface.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          DefaultTextStyle(
            style: AppFonts.inter.copyWith(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              color: surface.secondaryText,
            ),
            child: child,
          ),
          if (showAction) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            Divider(height: DesignTokens.spacingSm * 2, color: surface.cardBorder.withValues(alpha: 0.2)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: accent.primaryFixed,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: DesignTokens.spacingSm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel!.toUpperCase(),
                  style: AppFonts.inter.copyWith(
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
