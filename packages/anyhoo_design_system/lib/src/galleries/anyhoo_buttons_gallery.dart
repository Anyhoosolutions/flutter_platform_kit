import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Showcase of round / add / minus / remove buttons.
class AnyhooButtonsGallery extends StatelessWidget {
  const AnyhooButtonsGallery({super.key, this.enabled = true});

  /// When false, [AnyhooRoundButton] is shown disabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = context.accent.primaryFixed;

    final buttons = <Widget>[
      AnyhooRoundButton(icon: Icons.hourglass_bottom, color: color, onPressed: enabled ? () {} : null),
      AnyhooAddButton(color: color, onPressed: () {}),
      AnyhooMinusButton(color: color, onPressed: () {}),
      AnyhooRemoveButton(color: color, onPressed: () {}),
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final button in buttons) ...[
            Text(
              button.runtimeType.toString(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: context.surface.primaryText, fontWeight: FontWeight.w600),
            ),
            button,
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ],
      ),
    );
  }
}
