import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Elevated card with a tinted header bar for strong visual hierarchy.
///
/// Matches the Stitch "Header Card" pattern: primary-container header with
/// optional leading icon + title, and a surface body for [child].
class AnyhooHeaderCard extends StatelessWidget {
  const AnyhooHeaderCard({
    super.key,
    required this.title,
    required this.child,
    this.leadingIcon,
  });

  final String title;
  final Widget child;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return AnyhooCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: accent.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: 12,
              ),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 20, color: accent.onPrimaryContainer),
                    const SizedBox(width: DesignTokens.spacingSm),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppFonts.inter.copyWith(
                        fontSize: 20,
                        height: 28 / 20,
                        fontWeight: FontWeight.w600,
                        color: accent.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: DefaultTextStyle(
              style: AppFonts.inter.copyWith(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
                color: surface.secondaryText,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
