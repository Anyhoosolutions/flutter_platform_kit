/// How selected values are shown in the [AnyhooMultiSelect] field.
enum AnyhooMultiSelectValueDisplay {
  /// One chip per value (with optional truncation via [AnyhooMultiSelect.maxVisibleChips]).
  chips,

  /// Labels joined as a single string (e.g. `Cat, Pig, Chicken`).
  commaSeparated,
}
