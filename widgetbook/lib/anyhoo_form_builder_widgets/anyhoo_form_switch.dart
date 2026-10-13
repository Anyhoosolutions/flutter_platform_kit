import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'AnyhooFormSwitch', type: AnyhooFormSwitch, path: 'anyhoo_form_builder_widgets')
Widget buildAnyhooFormSwitch(BuildContext context) {
  final initialValue = context.knobs.boolean(label: 'Initial value', initialValue: true);
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    _FormSwitchPage(initialValue: initialValue),
  );
}

class _FormSwitchPage extends StatefulWidget {
  const _FormSwitchPage({required this.initialValue});

  final bool initialValue;

  @override
  State<_FormSwitchPage> createState() => _FormSwitchPageState();
}

class _FormSwitchPageState extends State<_FormSwitchPage> {
  var _generation = 0;
  late bool _seed = widget.initialValue;
  bool? _liveValue;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final current = _liveValue ?? _seed;

    return ColoredBox(
      color: surface.scaffoldBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'The switch reads its seed when the form mounts. Toggling it keeps that new value. '
                'Change the Initial value knob, then Apply initial value to mount again with that seed.',
                style: AnyhooTypography.body(BodySize.medium).copyWith(color: surface.secondaryText),
              ),
              const SizedBox(height: DesignTokens.spacingLg),
              FormBuilder(
                key: ValueKey(_generation),
                child: AnyhooFormSwitch(
                  name: 'enabled',
                  label: 'Enabled',
                  initialValue: _seed,
                  onChanged: (value) => setState(() => _liveValue = value),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                'Field value: $current',
                style: AnyhooTypography.body(BodySize.large).copyWith(color: surface.primaryText),
              ),
              const SizedBox(height: DesignTokens.spacingLg),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generation++;
                    _seed = widget.initialValue;
                    _liveValue = null;
                  });
                },
                child: const Text('Apply initial value'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
