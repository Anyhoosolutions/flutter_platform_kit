import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: Text, path: 'app_image_selector')
Widget build(BuildContext context) {
  final widget = Container(
    child: ElevatedButton(onPressed: () {}, child: Text('Hello World!')),
    color: Colors.red,
    width: 100,
    height: 100,
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
