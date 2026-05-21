import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_section.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_style.dart';
import 'package:anyhoo_form_builder_widgets/src/anyhoo_multi_select_value_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AnyhooFormBuilderMultiSelect<T extends Object> extends StatelessWidget {
  const AnyhooFormBuilderMultiSelect({
    super.key,
    required this.name,
    required this.labelBuilder,
    this.items,
    this.sections,
    this.initialValue,
    this.searchEnabled = true,
    this.allowAddNew = false,
    this.createItem,
    this.style,
    this.label,
    this.semanticLabel,
    this.emptySelectionHint = 'Select items...',
    this.validator,
    this.valueDisplay = AnyhooMultiSelectValueDisplay.chips,
    this.valueSeparator = ', ',
    this.commaSeparatedMaxLines = 2,
    this.maxVisibleChips = 3,
    this.singleSelection = false,
  }) : assert(items != null || sections != null, 'Provide either items or sections'),
       assert(items == null || sections == null, 'Provide only one of items or sections'),
       assert(!allowAddNew || sections == null, 'allowAddNew requires flat items mode');

  final String name;
  final String Function(T item) labelBuilder;
  final List<T>? items;
  final List<AnyhooMultiSelectSection<T>>? sections;
  final List<T>? initialValue;
  final bool searchEnabled;
  final bool allowAddNew;
  final T Function(String label)? createItem;
  final AnyhooMultiSelectStyle? style;
  final String? label;
  final String? semanticLabel;
  final String emptySelectionHint;
  final FormFieldValidator<List<T>>? validator;
  final AnyhooMultiSelectValueDisplay valueDisplay;
  final String valueSeparator;
  final int commaSeparatedMaxLines;
  final int maxVisibleChips;
  final bool singleSelection;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<T>>(
      name: name,
      initialValue: initialValue ?? [],
      validator: validator,
      builder: (field) {
        final value = field.value ?? [];
        return AnyhooMultiSelect<T>(
          labelBuilder: labelBuilder,
          value: value,
          onChanged: field.didChange,
          items: items,
          sections: sections,
          searchEnabled: searchEnabled,
          allowAddNew: allowAddNew,
          createItem: createItem,
          style: style,
          label: label,
          semanticLabel: semanticLabel,
          emptySelectionHint: emptySelectionHint,
          valueDisplay: valueDisplay,
          valueSeparator: valueSeparator,
          commaSeparatedMaxLines: commaSeparatedMaxLines,
          maxVisibleChips: maxVisibleChips,
          singleSelection: singleSelection,
        );
      },
    );
  }
}
