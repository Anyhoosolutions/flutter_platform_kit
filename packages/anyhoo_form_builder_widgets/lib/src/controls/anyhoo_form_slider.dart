import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormSlider extends StatelessWidget {
  const AnyhooFormSlider({
    super.key,
    required this.name,
    required this.min,
    required this.max,

    this.divisions,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String name;
  final double min;
  final double max;
  final int? divisions;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: min,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      builder: (FormFieldState<double> field) {
        return AnyhooSlider(
          onChanged: (value) => field.didChange(value),
          min: min,
          max: max,
          divisions: divisions,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          value: field.value ?? min,
        );
      },
    );
  }
}
