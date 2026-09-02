import 'anyhoo_dropdown_option.dart';

/// A titled group of options in [AnyhooDropdown].
///
/// When [groups] are used, add-new ([AnyhooDropdown.onCreate]) is not allowed.
class AnyhooDropdownGroup<T> {
  const AnyhooDropdownGroup({required this.title, required this.options});

  final String title;
  final List<AnyhooDropdownOption<T>> options;
}
