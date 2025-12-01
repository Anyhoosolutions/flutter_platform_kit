// ignore_for_file: deprecated_member_use

import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooFormBuilderMultiSelectSearchable, path: 'anyhoo_form_builder_widgets')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['red', 'green', 'purple'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'red');

  final _formKey = GlobalKey<FormBuilderState>();

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
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
                  _formKey.currentState?.save();
                  print(_formKey.currentState?.value);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}

ColorScheme getColorScheme(String colorScheme) {
  final color = switch (colorScheme) {
    'red' => Colors.red,
    'green' => Colors.green,
    'purple' => Colors.purple,
    _ => Colors.white,
  };
  final cs = ColorScheme.fromSeed(seedColor: color);
  return switch (colorScheme) {
    'red' => cs.copyWith(primary: Colors.red, brightness: Brightness.dark),
    'green' => cs.copyWith(primary: Colors.green, brightness: Brightness.dark),
    'purple' => cs.copyWith(primary: Colors.purple, brightness: Brightness.dark),
    _ => cs,
  };
}
