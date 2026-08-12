import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooRoundButton, path: 'anyhoo_design_system/buttons')
Widget buildAnyhooRoundButton(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, _AnyhooRoundButtonShowcase(enabled: enabled));
}

class _AnyhooRoundButtonShowcase extends StatelessWidget {
  const _AnyhooRoundButtonShowcase({required this.enabled});

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
