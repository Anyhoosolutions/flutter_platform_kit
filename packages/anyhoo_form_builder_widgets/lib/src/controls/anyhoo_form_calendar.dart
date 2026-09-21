import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormCalendar extends StatelessWidget {
  const AnyhooFormCalendar({super.key, required this.name, this.validators, this.onChanged});

  final String name;
  final List<FormFieldValidator<DateTime>>? validators;
  final void Function(DateTime)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: DateTime.now(),
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<DateTime>>[]),
      builder: (FormFieldState<DateTime> field) {
        return AnyhooCalendar(
          selectedDate: field.value ?? DateTime.now(),
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
