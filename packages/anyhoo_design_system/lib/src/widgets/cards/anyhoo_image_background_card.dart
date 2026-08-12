import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Simple elevated card with title, body, and an optional text action.
class AnyhooImageBackgroundCard extends StatelessWidget {
  const AnyhooImageBackgroundCard({
    super.key,
    required this.title,
    required this.child,
    required this.backgroundImageUrl,
    required this.height,
  });

  final String title;
  final Widget child;
  final String backgroundImageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return AnyhooCardShell(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      backgroundImageUrl: backgroundImageUrl,
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppFonts.inter.copyWith(
                fontSize: 20,
                height: 28 / 20,
                fontWeight: FontWeight.w600,
                color: surface.primaryText,
              ),
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
          ],
        ),
      ),
    );
  }
}
