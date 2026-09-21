import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'AnyhooFormGallery', type: AnyhooFormGallery, path: 'anyhoo_form_builder_widgets')
Widget buildAnyhooFormBuilderDropdownOverview(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const AnyhooFormGallery());
}
