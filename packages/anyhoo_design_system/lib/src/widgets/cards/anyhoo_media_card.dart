import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Hero / media card with a 16:9 image, title, body, and optional actions.
class AnyhooMediaCard extends StatelessWidget {
  const AnyhooMediaCard({
    super.key,
    required this.title,
    required this.child,
    this.image,
    this.imageUrl,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final Widget child;
  final Widget? image;
  final String? imageUrl;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final showPrimary = primaryActionLabel != null && onPrimaryAction != null;
    final showSecondary = secondaryActionLabel != null && onSecondaryAction != null;

    return AnyhooCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: surface.containerHighest,
              child: image ??
                  (imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Icon(Icons.image_outlined, size: 48, color: surface.secondaryText)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppFonts.inter.copyWith(
                    fontSize: 24,
                    height: 32 / 24,
                    fontWeight: FontWeight.w600,
                    color: surface.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                DefaultTextStyle(
                  style: AppFonts.inter.copyWith(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w400,
                    color: surface.secondaryText,
                  ),
                  child: child,
                ),
                if (showPrimary || showSecondary) ...[
                  const SizedBox(height: DesignTokens.spacingSm),
                  Row(
                    children: [
                      if (showPrimary)
                        FilledButton(
                          onPressed: onPrimaryAction,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent.primaryFixed,
                            foregroundColor: accent.onPrimaryFixed,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingMd,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            primaryActionLabel!,
                            style: AppFonts.inter.copyWith(
                              fontSize: 14,
                              height: 20 / 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (showPrimary && showSecondary) const SizedBox(width: DesignTokens.spacingSm),
                      if (showSecondary)
                        OutlinedButton(
                          onPressed: onSecondaryAction,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accent.primaryFixed,
                            side: BorderSide(color: surface.cardBorder),
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingMd,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                            ),
                          ),
                          child: Text(
                            secondaryActionLabel!,
                            style: AppFonts.inter.copyWith(
                              fontSize: 14,
                              height: 20 / 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
