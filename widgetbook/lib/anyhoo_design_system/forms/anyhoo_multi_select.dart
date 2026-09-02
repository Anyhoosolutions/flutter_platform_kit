// ignore_for_file: deprecated_member_use

import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Flat with add new', type: AnyhooMultiSelect, path: 'anyhoo_design_system/forms')
Widget buildFlatAddNew(BuildContext context) {
  return WrapInMocksHelper().wrapInMocks(context, _FlatAddNewDemo());
}

@widgetbook.UseCase(name: 'Single selection', type: AnyhooMultiSelect, path: 'anyhoo_design_system/forms')
Widget buildSingleSelection(BuildContext context) {
  return WrapInMocksHelper().wrapInMocks(context, _SingleSelectionDemo());
}

@widgetbook.UseCase(name: 'Sectioned', type: AnyhooMultiSelect, path: 'anyhoo_design_system/forms')
Widget buildSectioned(BuildContext context) {
  return WrapInMocksHelper().wrapInMocks(context, _SectionedDemo());
}

class _SectionedDemo extends StatefulWidget {
  @override
  State<_SectionedDemo> createState() => _SectionedDemoState();
}

class _SectionedDemoState extends State<_SectionedDemo> {
  static const _sections = [
    AnyhooMultiSelectSection(title: 'Pets', items: ['Dog', 'Cat', 'Bird']),
    AnyhooMultiSelectSection(title: 'Farm Animals', items: ['Cow', 'Pig', 'Chicken']),
  ];

  List<String> _value = const ['Dog', 'Cat', 'Bird', 'Cow', 'Pig', 'Chicken'];

  @override
  Widget build(BuildContext context) {
    final showCloseButton = context.knobs.boolean(label: 'Show close button', initialValue: true);
    final showSearch = context.knobs.boolean(label: 'Show search', initialValue: true);
    final displayMode = context.knobs.list(
      label: 'Value display',
      options: ['chips', 'commaSeparated', 'custom'],
      initialOption: 'custom',
    );

    final style = AnyhooMultiSelectStyle(
      sectionHeaderBackgroundColor: Color(0xFFFF9800),
      sectionHeaderStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
      overlayBackgroundColor: Color(0xFFFF9800),
      checkboxActiveColor: Color(0xFF3E2723),
      itemTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
      closeOverlayButtonLabel: showCloseButton ? 'Close' : null,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnyhooMultiSelect<String>(
          label: 'Animals',
          labelBuilder: (item) => item,
          value: _value,
          sections: _sections,
          searchEnabled: showSearch,
          valueDisplay: switch (displayMode) {
            'commaSeparated' => AnyhooMultiSelectValueDisplay.commaSeparated,
            'custom' => AnyhooMultiSelectValueDisplay.custom,
            _ => AnyhooMultiSelectValueDisplay.chips,
          },
          valueTextBuilder: displayMode == 'custom'
              ? (selected, allItems, labelBuilder) {
                  if (selected.length == allItems.length) return 'All';
                  return selected.map(labelBuilder).join(', ');
                }
              : null,
          style: style,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}

class _FlatAddNewDemo extends StatefulWidget {
  @override
  State<_FlatAddNewDemo> createState() => _FlatAddNewDemoState();
}

class _FlatAddNewDemoState extends State<_FlatAddNewDemo> {
  List<String> _value = ['Third', 'Second'];

  @override
  Widget build(BuildContext context) {
    final showCloseButton = context.knobs.boolean(label: 'Show close button', initialValue: true);
    final showSearch = context.knobs.boolean(label: 'Show search', initialValue: true);
    final allowAddNew = context.knobs.boolean(label: 'Allow add new', initialValue: true);
    final useCommaSeparated = context.knobs.boolean(label: 'Comma separated display', initialValue: false);

    final earthyStyle = AnyhooMultiSelectStyle(
      chipBackgroundColor: Color(0xFF5D4037),
      chipLabelStyle: TextStyle(color: Colors.white),
      chipDeleteIconColor: Colors.white,
      overlayBackgroundColor: Color(0xFFE8DCC8),
      itemTextStyle: TextStyle(color: Color(0xFF558B2F)),
      checkboxActiveColor: Color(0xFF5D4037),
      closeOverlayButtonLabel: showCloseButton ? 'Close' : null,
      searchHintText: allowAddNew ? 'Search or add new...' : 'Search...',
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnyhooMultiSelect<String>(
          label: 'Select a string',
          labelBuilder: (item) => item,
          value: _value,
          items: const ['First', 'Second', 'Third'],
          allowAddNew: allowAddNew,
          searchEnabled: showSearch,
          valueDisplay: useCommaSeparated
              ? AnyhooMultiSelectValueDisplay.commaSeparated
              : AnyhooMultiSelectValueDisplay.chips,
          style: earthyStyle,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}

class _SingleSelectionDemo extends StatefulWidget {
  @override
  State<_SingleSelectionDemo> createState() => _SingleSelectionDemoState();
}

class _SingleSelectionDemoState extends State<_SingleSelectionDemo> {
  List<String> _value = const ['Cat'];

  @override
  Widget build(BuildContext context) {
    final showSearch = context.knobs.boolean(label: 'Show search', initialValue: true);
    final sectioned = context.knobs.boolean(label: 'Sectioned', initialValue: false);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnyhooMultiSelect<String>(
          label: sectioned ? 'Animal' : 'Option',
          labelBuilder: (item) => item,
          value: _value,
          singleSelection: true,
          emptySelectionHint: 'Select an item...',
          searchEnabled: showSearch,
          items: sectioned ? null : const ['First', 'Second', 'Third'],
          sections: sectioned
              ? const [
                  AnyhooMultiSelectSection(title: 'Pets', items: ['Dog', 'Cat', 'Bird']),
                  AnyhooMultiSelectSection(title: 'Farm Animals', items: ['Cow', 'Pig', 'Chicken']),
                ]
              : null,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
