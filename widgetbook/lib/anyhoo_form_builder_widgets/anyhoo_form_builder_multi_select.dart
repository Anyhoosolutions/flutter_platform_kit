// ignore_for_file: deprecated_member_use

import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooFormBuilderMultiSelect, path: 'anyhoo_form_builder_widgets')
Widget build(BuildContext context) {
  final formKey = GlobalKey<FormBuilderState>();

  final widget = Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnyhooFormBuilderMultiSelect<String>(
              formFieldKey: 'number',
              items: ['First', 'Second', 'Third'],
              labelExtractor: (Object item) {
                return item.toString();
              },
              hintText: 'Select a string',
              itemTypeText: 'Number',
              initialValue: ['Third', 'Second'],
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.save();
                // ignore: avoid_print
                print(formKey.currentState?.value);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
