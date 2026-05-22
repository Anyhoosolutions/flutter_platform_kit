/// Builds display text for selected values in [AnyhooMultiSelect].
///
/// [selected] is the current selection. [allItems] is the full catalog (flat
/// [items] plus any user-added entries, or all section items).
typedef AnyhooMultiSelectValueTextBuilder<T> = String Function(
  List<T> selected,
  List<T> allItems,
  String Function(T item) labelBuilder,
);

/// How selected values are shown in the [AnyhooMultiSelect] field.
enum AnyhooMultiSelectValueDisplay {
  /// One chip per value (with optional truncation via [AnyhooMultiSelect.maxVisibleChips]).
  chips,

  /// Labels joined as a single string (e.g. `Cat, Pig, Chicken`).
  commaSeparated,

  /// Text from [AnyhooMultiSelect.valueTextBuilder] (e.g. `All` when every item is selected).
  custom,
}
