import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooRoundButton, path: 'anyhoo_design_system')
Widget buildAnyhooRoundButton(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    _AnyhooRoundButtonShowcase(enabled: enabled),
  );
}

class _AnyhooRoundButtonShowcase extends StatelessWidget {
  const _AnyhooRoundButtonShowcase({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AnyhooRoundButton',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: context.surface.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Uses surface.cardBorder / secondaryText by default',
            style: TextStyle(color: context.surface.secondaryText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          AnyhooRoundButton(
            icon: Icons.add,
            onPressed: enabled ? () {} : null,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          AnyhooRoundButton(
            icon: Icons.favorite,
            color: context.accent.primaryFixed,
            onPressed: enabled ? () {} : null,
          ),
        ],
      ),
    );
  }
}
