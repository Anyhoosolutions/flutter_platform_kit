import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Compact metric / bento-style info card with icon, optional badge, and value.
class AnyhooMetricCard extends StatelessWidget {
  const AnyhooMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.analytics_outlined,
    this.badgeLabel,
    this.minHeight = 200,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? badgeLabel;
  final double minHeight;

  static const _secondaryContainer = Color(0xFFD0E1FB);
  static const _onSecondaryContainer = Color(0xFF54647A);

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return AnyhooCardShell(
      child: SizedBox(
        height: minHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _secondaryContainer.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _secondaryContainer,
                        ),
                        child: Icon(icon, color: _onSecondaryContainer),
                      ),
                      const Spacer(),
                      if (badgeLabel != null)
                        AnyhooChip(
                          label: badgeLabel!,
                          variant: AnyhooChipVariant.surface,
                          shape: AnyhooChipShape.pill,
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    label,
                    style: AppFonts.inter.copyWith(
                      fontSize: 20,
                      height: 28 / 20,
                      fontWeight: FontWeight.w600,
                      color: surface.primaryText,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    value,
                    style: AppFonts.inter.copyWith(
                      fontSize: 36,
                      height: 44 / 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.72,
                      color: accent.primaryFixed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
