/// A titled group of selectable items in [AnyhooMultiSelect] sectioned mode.
class AnyhooMultiSelectSection<T> {
  const AnyhooMultiSelectSection({required this.title, required this.items});

  final String title;
  final List<T> items;
}
