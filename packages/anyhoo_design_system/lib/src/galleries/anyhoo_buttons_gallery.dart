import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Showcase of Kinetic action buttons and icon round buttons.
class AnyhooButtonsGallery extends StatelessWidget {
  const AnyhooButtonsGallery({super.key, this.enabled = true});

  /// When false, action buttons and [AnyhooRoundButton] are shown disabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = context.accent.primaryFixed;
    final onPressed = enabled ? () {} : null;
    final surface = context.surface;

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.marginMobile),
      children: [
        Text(
          'Action buttons',
          style: AnyhooTypography.headline(HeadlineSize.small).copyWith(color: surface.primaryText),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          'Primary, secondary, and text — Kinetic Logic',
          style: AnyhooTypography.body(BodySize.medium).copyWith(color: surface.secondaryText),
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        Wrap(
          spacing: DesignTokens.spacingMd,
          runSpacing: DesignTokens.spacingMd,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AnyhooPrimaryButton(label: 'Primary', onPressed: onPressed),
            AnyhooSecondaryButton(label: 'Secondary', onPressed: onPressed),
            AnyhooTextButton(label: 'Text Button', onPressed: onPressed),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        AnyhooPrimaryButton(
          label: 'Full width primary',
          onPressed: onPressed,
          fullWidth: true,
          leadingIcon: Icons.check,
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        AnyhooSecondaryButton(
          label: 'Full width secondary',
          onPressed: onPressed,
          fullWidth: true,
          trailingIcon: Icons.arrow_forward,
        ),
        const SizedBox(height: DesignTokens.spacingXl),
        Text(
          'Icon buttons',
          style: AnyhooTypography.headline(HeadlineSize.small).copyWith(color: surface.primaryText),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        Wrap(
          spacing: DesignTokens.spacingLg,
          runSpacing: DesignTokens.spacingMd,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AnyhooRoundButton(icon: Icons.hourglass_bottom, color: color, onPressed: onPressed),
            AnyhooAddButton(color: color, onPressed: () {}),
            AnyhooMinusButton(color: color, onPressed: () {}),
            AnyhooRemoveButton(color: color, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
