// ignore_for_file: deprecated_member_use

import 'package:anyhoo_form_builder_widgets/anyhoo_form_builder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Flat with add new', type: AnyhooMultiSelect, path: 'anyhoo_form_builder_widgets')
Widget buildFlatAddNew(BuildContext context) {
  return WrapInMocksHelper().wrapInMocks(context, _FlatAddNewDemo());
}

@widgetbook.UseCase(name: 'Sectioned', type: AnyhooMultiSelect, path: 'anyhoo_form_builder_widgets')
Widget buildSectioned(BuildContext context) {
  const style = AnyhooMultiSelectStyle(
    sectionHeaderBackgroundColor: Color(0xFFFF9800),
    sectionHeaderStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E), fontSize: 14),
    overlayBackgroundColor: Color(0xFFFF9800),
    checkboxActiveColor: Color(0xFF3E2723),
    itemTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
  );

  return WrapInMocksHelper().wrapInMocks(
    context,
    Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnyhooMultiSelect<String>(
          label: 'Animals',
          labelBuilder: (item) => item,
          value: const ['Cat', 'Pig'],
          sections: const [
            AnyhooMultiSelectSection(title: 'Pets', items: ['Dog', 'Cat', 'Bird']),
            AnyhooMultiSelectSection(title: 'Farm Animals', items: ['Cow', 'Pig', 'Chicken']),
          ],
          searchEnabled: false,
          style: style,
          onChanged: (_) {},
        ),
      ),
    ),
  );
}

class _FlatAddNewDemo extends StatefulWidget {
  @override
  State<_FlatAddNewDemo> createState() => _FlatAddNewDemoState();
}

class _FlatAddNewDemoState extends State<_FlatAddNewDemo> {
  List<String> _value = ['Third', 'Second'];

  static const _earthyStyle = AnyhooMultiSelectStyle(
    chipBackgroundColor: Color(0xFF5D4037),
    chipLabelStyle: TextStyle(color: Colors.white),
    chipDeleteIconColor: Colors.white,
    overlayBackgroundColor: Color(0xFFE8DCC8),
    itemTextStyle: TextStyle(color: Color(0xFF558B2F)),
    checkboxActiveColor: Color(0xFF5D4037),
    closeOverlayButtonLabel: 'Close',
    searchHintText: 'Search or add new...',
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnyhooMultiSelect<String>(
          label: 'Select a string',
          labelBuilder: (item) => item,
          value: _value,
          items: const ['First', 'Second', 'Third'],
          allowAddNew: true,
          style: _earthyStyle,
          onChanged: (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
