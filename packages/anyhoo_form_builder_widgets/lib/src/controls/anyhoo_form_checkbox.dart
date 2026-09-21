import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormCheckbox extends StatelessWidget {
  const AnyhooFormCheckbox({super.key, required this.name, required this.label});

  final String label;
  final String name;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      initialValue: false,
      name: name,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      builder: (FormFieldState<bool> field) {
        final isSelected = field.value ?? false;

        return AnyhooCheckbox(
          label: label,
          value: isSelected,
          onChanged: (value) {
            field.didChange(value);
          },
        );
      },
    );
  }
}
