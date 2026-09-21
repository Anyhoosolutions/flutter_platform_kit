import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:anyhoo_design_system/anyhoo_design_system.dart';

class AnyhooFormSegmentControl<T> extends StatelessWidget {
  const AnyhooFormSegmentControl({super.key, required this.name, required this.segments, this.validators});

  final String name;
  final List<AnyhooSegment<T>> segments;
  final List<FormFieldValidator<T>>? validators;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      initialValue: segments.first.value,
      name: name,
      validator: FormBuilderValidators.compose(validators ?? <FormFieldValidator<T>>[]),
      builder: (FormFieldState<T> field) {
        return AnyhooSegmentedControl<T>(
          onChanged: (value) => field.didChange(value),
          segments: segments,
          selected: field.value ?? segments.first.value,
        );
      },
    );
  }
}
