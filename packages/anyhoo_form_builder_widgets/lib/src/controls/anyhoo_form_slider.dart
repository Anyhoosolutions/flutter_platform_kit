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
    this.validators,
    this.divisions,
    this.leadingIcon,
    this.trailingIcon,
    this.onChanged,
    this.initialValue,
  });

  final String name;
  final double min;
  final double max;
  final int? divisions;
  final List<FormFieldValidator<double>>? validators;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final void Function(double)? onChanged;
  final double? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: initialValue,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<double>>[]),
      builder: (FormFieldState<double> field) {
        return AnyhooSlider(
          value: field.value ?? initialValue ?? min,
          onChanged: (value) {
            field.didChange(value);
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          min: min,
          max: max,
          divisions: divisions,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
        );
      },
    );
  }
}
