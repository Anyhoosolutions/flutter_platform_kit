// ignore_for_file: deprecated_member_use

import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'FirebaseAnalyticsPage', type: FirebaseAnalyticsPage, path: 'anyhoo_firebase')
Widget build(BuildContext context) {
  final widget = FirebaseAnalyticsPage();

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
