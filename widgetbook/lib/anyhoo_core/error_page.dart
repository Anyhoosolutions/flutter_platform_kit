// ignore_for_file: deprecated_member_use

import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'ErrorPage', type: ErrorPage, path: 'anyhoo_core')
Widget build(BuildContext context) {
  final widget = Center(
    child: Stack(
      children: [
        // Simulating how it might be used in a real app - inside a Stack
        // This could be a form page with other widgets stacked on top
        ErrorPage(errorMessage: "Couldn't load the page", detailedError: "Detailed error message"),
      ],
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
