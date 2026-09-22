import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

typedef Label = String;

class AnyhooFormRadioGroup<T> extends StatelessWidget {
  const AnyhooFormRadioGroup({
    super.key,
    required this.name,
    required this.options,
    this.validators,
    this.onChanged,
    this.initialValue,
  });

  final String name;
  final List<(T, Label)> options;
  final List<FormFieldValidator<T>>? validators;
  final void Function(T)? onChanged;
  final T? initialValue;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      initialValue: initialValue ?? options.first.$1,
      name: name,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<T>>[]),
      builder: (FormFieldState<T> field) {
        return Wrap(
          children: options
              .map(
                (o) => _radio(field.value, o.$1, o.$2, (T? t) {
                  field.didChange(t);
                  if (onChanged != null) {
                    onChanged!(o.$1);
                  }
                }),
              )
              .toList(),
        );
      },
    );
  }

  Widget _radio(T? groupValue, T value, Label label, ValueChanged<T?> onChanged) {
    return AnyhooRadio(label: label, value: value, groupValue: groupValue, onChanged: onChanged);
  }
}
