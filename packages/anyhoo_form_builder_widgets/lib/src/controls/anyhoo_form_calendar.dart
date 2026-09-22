import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormCalendar extends StatelessWidget {
  const AnyhooFormCalendar({super.key, required this.name, this.validators, this.onChanged, this.initialValue});

  final String name;
  final List<FormFieldValidator<DateTime>>? validators;
  final void Function(DateTime)? onChanged;
  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    final initValue = initialValue ?? DateTime.now();

    return FormBuilderField(
      name: name,
      initialValue: initValue,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<DateTime>>[]),
      builder: (FormFieldState<DateTime> field) {
        return AnyhooCalendar(
          selectedDate: field.value ?? initValue,
          onDateSelected: (d) {
            field.didChange(d);
            if (onChanged != null) {
              onChanged!(d);
            }
          },
        );
      },
    );
  }
}
