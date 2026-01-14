// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:anyhoo_core/widgets/error_display_widget.dart';
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'ErrorDisplayWidget', type: ErrorDisplayWidget, path: 'anyhoo_core')
Widget build(BuildContext context) {
  final widget = Center(
    child: Stack(
      children: [
        // Simulating how it might be used in a real app - inside a Stack
        // This could be a form page with other widgets stacked on top
        ErrorDisplayWidget(
          errorDetails: FlutterErrorDetails(exception: Exception('Test error'), stack: StackTrace.current),
        ),
      ],
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
