import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormSwitch extends StatelessWidget {
  const AnyhooFormSwitch({
    super.key,
    required this.name,
    required this.label,
    this.validators,
    this.onChanged,
    this.initialValue = false,
  });

  final String label;
  final String name;
  final List<FormFieldValidator<bool>>? validators;
  final void Function(bool)? onChanged;
  final bool initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      initialValue: initialValue,
      name: name,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<bool>>[]),
      builder: (FormFieldState<bool> field) {
        return AnyhooSwitch(
          label: label,
          value: field.value ?? initialValue,
          onChanged: (value) {
            field.didChange(value);
            if (onChanged != null) {
              onChanged!(value);
            }
          },
        );
      },
    );
  }
}
