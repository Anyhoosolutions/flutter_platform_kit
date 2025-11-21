// ignore_for_file: deprecated_member_use

import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'ErrorPage', type: ErrorPage)
Widget build(BuildContext context) {
  final colorSchemeOptions = ['red', 'green', 'purple'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'red');

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: Center(
      child: SizedBox(
        width: 300,
        height: 400,
        child: Stack(
          children: [
            // Simulating how it might be used in a real app - inside a Stack
            // This could be a form page with other widgets stacked on top
            ErrorPage(errorMessage: "Couldn't load the page", detailedError: "Detailed error message"),
          ],
        ),
      ),
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}

ColorScheme getColorScheme(String colorScheme) {
  final cs = ColorScheme.fromSeed(seedColor: Colors.white);
  return switch (colorScheme) {
    'red' => cs.copyWith(primary: Colors.red),
    'green' => cs.copyWith(primary: Colors.green),
    'purple' => cs.copyWith(primary: Colors.purple),
    _ => cs,
  };
}
