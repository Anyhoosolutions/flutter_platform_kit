// ignore_for_file: deprecated_member_use

import 'package:anyhoo_core/widgets/waiting_page.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'WaitingPage', type: WaitingPage, path: 'anyhoo_core')
Widget build(BuildContext context) {
  final widget = Center(
    child: SizedBox(
      width: 300,
      height: 400,
      child: Stack(
        children: [
          // Simulating how it might be used in a real app - inside a Stack
          // This could be a form page with other widgets stacked on top
          WaitingPage(message: "Loading the page"),
        ],
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
