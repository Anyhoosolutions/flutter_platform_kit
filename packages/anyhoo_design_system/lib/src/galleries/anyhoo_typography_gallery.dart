import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Showcase of typography scale and themed text samples.
class AnyhooTypographyGallery extends StatelessWidget {
  const AnyhooTypographyGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Typography & Theming'.display(size: DisplaySize.medium),
            const SizedBox(height: DesignTokens.spacingSm),
            'Precision Minimalism design system. High-contrast typography and purposeful depth for a professional, neutral, and dependable aesthetic.'
                .body(size: BodySize.large),
            const SizedBox(height: DesignTokens.spacingLg),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  'Typography Scale'.headline(size: HeadlineSize.small),
                  Divider(height: DesignTokens.spacingLg, color: surface.cardBorder.withValues(alpha: 0.5)),
                  _ScaleRow(
                    role: 'Display Large',
                    sample: 'Precision Design'.display(size: DisplaySize.large),
                  ),
                  _ScaleRow(
                    role: 'Headline Med',
                    sample: 'Structured Hierarchy'.headline(size: HeadlineSize.medium),
                  ),
                  _ScaleRow(
                    role: 'Headline Small',
                    sample: 'Clear Spatial Logic'.headline(size: HeadlineSize.small),
                  ),
                  _ScaleRow(
                    role: 'Body Large',
                    sample:
                        'The target audience includes professional users who require high-density information without cognitive overload.'
                            .body(size: BodySize.large, color: surface.primaryText),
                  ),
                  _ScaleRow(
                    role: 'Label Medium',
                    sample: 'DESIGN TOKENS APPLIED'.label(size: LabelSize.medium),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette, color: context.accent.primaryFixed),
                      const SizedBox(width: DesignTokens.spacingSm),
                      'Default Theme'.headline(size: HeadlineSize.small),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  'Uses standard surface colors and typography for neutral content blocks.'.body(),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}

class _ScaleRow extends StatelessWidget {
  const _ScaleRow({required this.role, required this.sample, this.showDivider = true});

  final String role;
  final Widget sample;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        role.label(size: LabelSize.medium, color: surface.secondaryText),
        const SizedBox(height: DesignTokens.spacingSm),
        sample,
        if (showDivider)
          Divider(height: DesignTokens.spacingLg, color: surface.cardBorder.withValues(alpha: 0.2))
        else
          const SizedBox(height: DesignTokens.spacingSm),
      ],
    );
  }
}
