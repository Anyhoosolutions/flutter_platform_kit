extension NumExtension on num {
  // Duration helpers
  Duration get ms => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
}

extension IntExtension on int {
  /// Generates a list of integers from this to end (inclusive)
  Iterable<int> to(int end) {
    return List.generate(end - this + 1, (index) => this + index);
  }

  /// Generates a list of integers from this to end (exclusive)
  Iterable<int> upTo(int end) {
    return List.generate(end - this, (index) => this + index);
  }
}
