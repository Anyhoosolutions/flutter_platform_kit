# Changelog

## 0.2.1

* Added `AnyhooFormBuilderDropdown` (`.single` / `.multi`) wrapping `AnyhooDropdown`.

## 0.2.0

**Breaking:** Visual multi-select widgets moved to `anyhoo_design_system`.

- `AnyhooMultiSelect`, `AnyhooMultiSelectSection`, `AnyhooMultiSelectStyle`, and
  `AnyhooMultiSelectValueDisplay` now live in the design system.
- This package re-exports those types and keeps `AnyhooFormBuilderMultiSelect` as a
  `flutter_form_builder` adapter.

## 0.1.0

**Breaking:** Unified multi-select API.

- Added `AnyhooMultiSelect<T>`, `AnyhooMultiSelectSection<T>`, `AnyhooMultiSelectStyle`
- Replaced `AnyhooFormBuilderMultiSelect` implementation (removed `multi_dropdown` dependency)
- Removed `AnyhooMultiSelectSearchable`, `AnyhooFormBuilderMultiSelectSearchable`
- Renamed parameters: `selectedItems` → `value`, `labelExtractor` → `labelBuilder`, `formFieldKey` → `name`

## 0.0.2

* Renaming in library

## 0.0.1

* AnyhooMultiSelectSearchable
* AnyhooFormBuilderMultiSelect
* AnyhooFormBuilderMultiSelectSearchable
