import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of chip components.
class AnyhooChipsGallery extends StatelessWidget {
  const AnyhooChipsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Variants'.headline(size: HeadlineSize.small).pad(b: 4),
            Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingSm,
              children: const [
                AnyhooChip(label: 'bg-surface-container-lowest'),
                AnyhooChip(label: 'bg-error-container', variant: AnyhooChipVariant.error),
                AnyhooChip(label: '+12%', variant: AnyhooChipVariant.surface, shape: AnyhooChipShape.pill),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Shapes'.headline(size: HeadlineSize.small).pad(b: 4),
            const Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingSm,
              children: [
                AnyhooChip(label: 'Rounded 8px'),
                AnyhooChip(label: 'Pill', shape: AnyhooChipShape.pill),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'With icon / delete'.headline(size: HeadlineSize.small).pad(b: 4),
            Wrap(
              spacing: DesignTokens.spacingSm,
              runSpacing: DesignTokens.spacingSm,
              children: [
                const AnyhooChip(label: 'Filter', leadingIcon: Icons.filter_list),
                AnyhooChip(
                  label: 'Removable',
                  shape: AnyhooChipShape.pill,
                  onDeleted: () {},
                ),
                AnyhooChip(
                  label: 'Tappable',
                  variant: AnyhooChipVariant.surface,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'On cards (from theming screen)'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette, color: context.accent.primaryFixed),
                      const SizedBox(width: DesignTokens.spacingSm),
                      'Default Theme'.headline(size: HeadlineSize.small),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  'Uses standard surface colors and typography for neutral content blocks.'
                      .body(size: BodySize.medium),
                  const SizedBox(height: DesignTokens.spacingMd),
                  const AnyhooChip(label: 'bg-surface-container-lowest'),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            AnyhooCardShell(
              backgroundColor: context.status.errorContainer,
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error, color: context.status.error),
                      const SizedBox(width: DesignTokens.spacingSm),
                      Text(
                        'Brand Override',
                        style: AnyhooTypography.headline(HeadlineSize.small).copyWith(
                          color: context.status.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacingSm),
                  Text(
                    'Demonstrates critical state override using semantic error tokens for immediate attention.',
                    style: AnyhooTypography.body(BodySize.medium).copyWith(
                      color: context.status.error.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  const AnyhooChip(
                    label: 'bg-error-container',
                    variant: AnyhooChipVariant.error,
                  ),
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
