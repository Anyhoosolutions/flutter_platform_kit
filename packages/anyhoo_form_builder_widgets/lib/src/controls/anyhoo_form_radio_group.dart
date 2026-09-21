import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

typedef Label = String;

class AnyhooFormRadioGroup<T> extends StatelessWidget {
  const AnyhooFormRadioGroup({super.key, required this.name, required this.options});

  final String name;
  final List<(T, Label)> options;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      initialValue: options.first.$1,
      name: name,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      builder: (FormFieldState<T> field) {
        return Wrap(
          children: options.map((o) => _radio(field.value, o.$1, o.$2, (T? t) => field.didChange(t))).toList(),
        );
      },
    );
  }

  Widget _radio(T? groupValue, T value, Label label, ValueChanged<T?> onChanged) {
    return AnyhooRadio(label: label, value: value, groupValue: groupValue, onChanged: onChanged);
  }
}
