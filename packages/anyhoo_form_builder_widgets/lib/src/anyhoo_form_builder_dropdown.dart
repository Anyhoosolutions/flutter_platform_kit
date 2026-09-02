import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Form Builder adapter for [AnyhooDropdown].
class AnyhooFormBuilderDropdown<T extends Object> extends StatelessWidget {
  const AnyhooFormBuilderDropdown.single({
    super.key,
    required this.name,
    this.options,
    this.groups,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.label,
    this.hint = 'Select...',
    this.onCreate,
    this.searchEnabled = false,
    this.semanticLabel,
    this.maxWidth = 280,
    this.maxVisibleOptions = 6,
  }) : assert(
         (options != null) ^ (groups != null),
         'Provide exactly one of options or groups',
       ),
       assert(onCreate == null || groups == null, 'onCreate is not supported with groups'),
       isMulti = false,
       multiInitialValue = null,
       multiValidator = null;

  const AnyhooFormBuilderDropdown.multi({
    super.key,
    required this.name,
    this.options,
    this.groups,
    List<T>? initialValue,
    FormFieldValidator<List<T>>? validator,
    this.enabled = true,
    this.label,
    this.hint = 'Select items...',
    this.onCreate,
    this.searchEnabled = false,
    this.semanticLabel,
    this.maxWidth = 280,
    this.maxVisibleOptions = 6,
  }) : assert(
         (options != null) ^ (groups != null),
         'Provide exactly one of options or groups',
       ),
       assert(onCreate == null || groups == null, 'onCreate is not supported with groups'),
       isMulti = true,
       initialValue = null,
       multiInitialValue = initialValue,
       multiValidator = validator,
       validator = null;

  final bool isMulti;
  final String name;
  final List<AnyhooDropdownOption<T>>? options;
  final List<AnyhooDropdownGroup<T>>? groups;
  final T? initialValue;
  final List<T>? multiInitialValue;
  final FormFieldValidator<T>? validator;
  final FormFieldValidator<List<T>>? multiValidator;
  final bool enabled;
  final String? label;
  final String hint;
  final T Function(String label)? onCreate;
  final bool searchEnabled;
  final String? semanticLabel;
  final double maxWidth;
  final int maxVisibleOptions;

  @override
  Widget build(BuildContext context) {
    if (isMulti) {
      return FormBuilderField<List<T>>(
        name: name,
        initialValue: multiInitialValue ?? [],
        validator: multiValidator,
        enabled: enabled,
        builder: (field) {
          return AnyhooDropdown<T>.multi(
            options: options,
            groups: groups,
            value: field.value ?? [],
            onChanged: field.didChange,
            label: label,
            hint: hint,
            onCreate: onCreate,
            searchEnabled: searchEnabled,
            semanticLabel: semanticLabel,
            maxWidth: maxWidth,
            maxVisibleOptions: maxVisibleOptions,
          );
        },
      );
    }

    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        return AnyhooDropdown<T>.single(
          options: options,
          groups: groups,
          value: field.value,
          onChanged: field.didChange,
          label: label,
          hint: hint,
          onCreate: onCreate,
          searchEnabled: searchEnabled,
          semanticLabel: semanticLabel,
          maxWidth: maxWidth,
          maxVisibleOptions: maxVisibleOptions,
        );
      },
    );
  }
}
