import 'package:flutter/widgets.dart';

/// A selectable row in [AnyhooDropdown].
class AnyhooDropdownOption<T> {
  const AnyhooDropdownOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;

  /// Optional leading icon for this row. Created items typically omit this.
  final IconData? icon;
}
