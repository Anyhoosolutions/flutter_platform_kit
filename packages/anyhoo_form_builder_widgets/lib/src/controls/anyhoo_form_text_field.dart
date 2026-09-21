import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormTextField extends StatelessWidget {
  const AnyhooFormTextField({
    super.key,
    required this.name,
    this.hint = 'Search',
    this.onFilterTap,
    this.isFilterActive = false,
    this.validators,
  });

  final String name;
  final List<FormFieldValidator<String>>? validators;
  final String hint;
  final VoidCallback? onFilterTap;

  /// When true, the filter icon uses the accent color. When false, it uses
  /// [SurfaceColors.secondaryText] (same as the search icon).
  final bool isFilterActive;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: '',
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<String>>[]),
      builder: (FormFieldState<String> field) {
        return AnyhooTextField(
          hint: hint,
          onChanged: (value) {
            field.didChange(value);
          },
          onFilterTap: onFilterTap,
          isFilterActive: isFilterActive,
        );
      },
    );
  }
}
