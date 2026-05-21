// ignore_for_file: deprecated_member_use

import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooMultiSelectSearchable, path: 'anyhoo_form_builder_widgets')
Widget build(BuildContext context) {
  final widget = Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnyhooMultiSelectSearchable(
        items: ['First', 'Second', 'Third'],
        hintText: 'Select a string',
        selectedItems: ['Third', 'Second'],
        onChanged: (items) {
          // ignore: avoid_print
          print('items: $items');
        },
      ),
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
