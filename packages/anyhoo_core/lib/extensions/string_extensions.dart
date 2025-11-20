extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String stripRight(String suffix) {
    while (true) {
      if (endsWith(suffix)) {
        return substring(0, length - suffix.length);
      }
      return this;
    }
  }

  String repeat(int n) {
    return List.generate(n, (index) => this).join();
  }
}
