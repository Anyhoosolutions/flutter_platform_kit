// ignore_for_file: deprecated_member_use

import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'FirebaseAnalyticsPage', type: FirebaseAnalyticsPage, path: '/anyhoo_firebase')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['green', 'purple', 'red'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'purple');

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: FirebaseAnalyticsPage(),
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
