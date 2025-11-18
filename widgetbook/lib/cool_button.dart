import 'package:app_image_selector/widgets/image_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: Text, path: 'app_image_selector')
Widget build(BuildContext context) {
  // final widget = Center(child: ImageSelectorWidget(onImageSelected: (state) {}));
  final widget = Center(child: Text('hello'));

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
