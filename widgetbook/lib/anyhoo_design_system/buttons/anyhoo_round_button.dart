import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/galleries.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooRoundButton, path: 'anyhoo_design_system/buttons')
Widget buildAnyhooRoundButton(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    SafeArea(child: AnyhooButtonsGallery(enabled: enabled)),
  );
}
