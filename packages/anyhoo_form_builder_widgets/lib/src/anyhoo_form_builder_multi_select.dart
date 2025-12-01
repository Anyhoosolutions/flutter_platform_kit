import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logging/logging.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

final _log = Logger('FormBuilderMultiSelect');

class AnyhooFormBuilderMultiSelect<T extends Object> extends StatelessWidget {
  AnyhooFormBuilderMultiSelect({
    super.key,
    required this.formFieldKey,
    required this.items,
    required this.labelExtractor,
    required this.hintText,
    required this.itemTypeText,
    this.initialValue,
  });

  final String formFieldKey;
  final List<T> items;
  final Function(T item) labelExtractor;
  final String hintText;
  final String itemTypeText;
  final List<T>? initialValue;

  final MultiSelectController<T> _controller = MultiSelectController<T>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _createItems();
    _log.info('initialValue: $initialValue');

    return FormBuilderField(
      key: Key(formFieldKey),
      name: formFieldKey,
      initialValue: initialValue,
      builder: (field) => Theme(
        data: theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
        child: MultiDropdown<T>(
          items: items,
          controller: _controller,
          enabled: true,
          searchEnabled: true,
          chipDecoration: ChipDecoration(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.8),
            wrap: true,
            runSpacing: 2,
            spacing: 10,
          ),
          fieldDecoration: FieldDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 16),
            prefixIcon: Icon(Icons.flag, color: theme.colorScheme.primary.withValues(alpha: 0.8)),
            showClearIcon: false,
            backgroundColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.tertiary),
            ),
          ),
          dropdownDecoration: DropdownDecoration(
            marginTop: 2,
            maxHeight: 500,
            backgroundColor: theme.colorScheme.surface,
            header: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Select $itemTypeText from the list',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
            ),
          ),
          dropdownItemDecoration: DropdownItemDecoration(
            selectedIcon: Icon(Icons.check_box, color: theme.colorScheme.primary),
            disabledIcon: Icon(Icons.lock, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $itemTypeText';
            }
            return null;
          },
          onSelectionChange: (selectedItems) {
            debugPrint("OnSelectionChange: $selectedItems");
            field.didChange(selectedItems);
          },
        ),
      ),
    );
  }

  List<DropdownItem<T>> _createItems() {
    return items.map((i) => _createItem(i)).toList();
  }

  DropdownItem<T> _createItem(T item) {
    return DropdownItem<T>(label: labelExtractor(item), value: item, selected: initialValue?.contains(item) ?? false);
  }
}
