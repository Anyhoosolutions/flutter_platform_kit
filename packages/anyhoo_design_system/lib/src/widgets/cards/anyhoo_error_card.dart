import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Simple elevated card with title, body, and an optional text action.
class AnyhooErrorCard extends StatelessWidget {
  const AnyhooErrorCard({super.key, required this.title, required this.child, this.actionLabel, this.onAction});

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final status = context.status;
    final showAction = actionLabel != null && onAction != null;

    return AnyhooCardShell(
      backgroundColor: Colors.red.shade200,
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: status.error).pad(r: 4),
              Text(
                title,
                style: AppFonts.inter.copyWith(
                  fontSize: 20,
                  height: 28 / 20,
                  fontWeight: FontWeight.w600,
                  color: status.error,
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
                    color: status.error,
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
