import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of breadcrumbs, steppers, expansion panels, and empty states.
class AnyhooNavigationGallery extends StatefulWidget {
  const AnyhooNavigationGallery({super.key});

  @override
  State<AnyhooNavigationGallery> createState() => _AnyhooNavigationGalleryState();
}

class _AnyhooNavigationGalleryState extends State<AnyhooNavigationGallery> {
  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return SafeArea(
      child: ColoredBox(
        color: surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            AnyhooBreadcrumb(
              items: [
                AnyhooBreadcrumbItem(label: 'Home', onTap: () {}),
                AnyhooBreadcrumbItem(label: 'Components', onTap: () {}),
                const AnyhooBreadcrumbItem(label: 'Navigation'),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Checkout Progress'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooCardShell(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: const AnyhooStepper(
                steps: ['Account', 'Shipping', 'Payment'],
                currentStep: 1,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Frequently Asked Questions'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooExpansionList(
              headerTitle: 'Frequently Asked Questions',
              panels: [
                AnyhooExpansionPanel(
                  title: 'How do I integrate the design tokens?',
                  initiallyExpanded: true,
                  child: Text(
                    'The design tokens are provided in the theme configuration. '
                    'Use AnyhooTheme.light() / dark() and DesignTokens for spacing and radii.',
                    style: AnyhooTypography.body(BodySize.medium).copyWith(
                      color: surface.secondaryText,
                    ),
                  ),
                ),
                const AnyhooExpansionPanel(
                  title: 'What is the baseline grid spacing?',
                  child: Text('Kinetic Logic uses a 4px baseline grid.'),
                ),
                const AnyhooExpansionPanel(
                  title: 'Can I use custom icons?',
                  child: Text('Yes — pass any IconData into the component APIs.'),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Empty state'.headline(size: HeadlineSize.small).pad(b: 8),
            AnyhooEmptyState(
              icon: Icons.search_off,
              title: 'No Results Found',
              message:
                  "We couldn't find any components matching your search criteria. Try adjusting your filters.",
              actionLabel: 'Try Again',
              onAction: () {},
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
