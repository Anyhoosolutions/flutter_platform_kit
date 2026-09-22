import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormDatePicker extends StatelessWidget {
  const AnyhooFormDatePicker({super.key, required this.name, this.validators, this.initialValue});

  final String name;
  final List<FormFieldValidator<DateTime>>? validators;
  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    final initValue = initialValue ?? DateTime.now();
    return FormBuilderField(
      name: name,
      initialValue: initValue,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<DateTime>>[]),
      builder: (FormFieldState<DateTime> field) {
        return AnyhooDateField(date: field.value ?? initValue, onTap: () {});
      },
    );
  }
}
