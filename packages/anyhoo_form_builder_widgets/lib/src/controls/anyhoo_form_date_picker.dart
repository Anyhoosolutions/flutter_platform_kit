import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormDatePicker extends StatelessWidget {
  const AnyhooFormDatePicker({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: DateTime.now(),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      builder: (FormFieldState<DateTime> field) {
        return AnyhooDateField(date: field.value ?? DateTime.now(), onTap: () {});
      },
    );
  }
}
