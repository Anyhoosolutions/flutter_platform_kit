import 'package:anyhoo_design_system/galleries.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'App Settings Screen', type: AnyhooAppSettingsScreen, path: 'anyhoo_design_system/screens')
Widget buildAppSettingsScreen(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const AnyhooAppSettingsScreen());
}
