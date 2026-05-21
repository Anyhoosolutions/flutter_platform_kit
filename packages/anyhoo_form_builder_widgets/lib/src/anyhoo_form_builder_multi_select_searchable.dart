import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_searchable.dart';

class AnyhooFormBuilderMultiSelectSearchable extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final String? hintText;
  final String formFieldKey;
  final String? semanticLabel;

  const AnyhooFormBuilderMultiSelectSearchable({
    super.key,
    required this.formFieldKey,
    required this.items,
    required this.selectedItems,
    this.hintText,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      key: Key(formFieldKey),
      name: formFieldKey,
      initialValue: selectedItems,
      builder: (field) => AnyhooMultiSelectSearchable(
        semanticLabel: semanticLabel,
        items: items,
        selectedItems: selectedItems,
        hintText: hintText,
        onChanged: (List<String> value) {
          field.didChange(value);
        },
      ),
    );
  }
}
