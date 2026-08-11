extension IterableExtension<T> on Iterable<T> {
  // Safe accessors
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  // Iteration

  // Data manipulation
  Map<K, List<T>> groupBy<K>(K Function(T item) keySelector) {
    final groups = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      groups.putIfAbsent(key, () => []).add(item);
    }
    return groups;
  }

  List<T> get distinct => toSet().toList();

  List<T> distinctBy(Object Function(T item) keySelector) {
    final seen = <Object>{};
    return where((item) => seen.add(keySelector(item))).toList();
  }
}
