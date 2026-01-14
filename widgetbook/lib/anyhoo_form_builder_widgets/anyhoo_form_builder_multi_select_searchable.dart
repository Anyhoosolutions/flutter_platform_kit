// ignore_for_file: deprecated_member_use

import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooFormBuilderMultiSelectSearchable, path: 'anyhoo_form_builder_widgets')
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
            AnyhooFormBuilderMultiSelectSearchable(
              items: ['First', 'Second', 'Third'],
              hintText: 'Select a string',
              selectedItems: ['Third', 'Second'],
              formFieldKey: 'number',
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
