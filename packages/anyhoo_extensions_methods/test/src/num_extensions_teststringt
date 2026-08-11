import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_extensions_methods/anyhoo_extensions_methods.dart';

void main() {
  group('generate list', () {
    test('inclusive', () {
      final result = 1.to(10);
      final expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      expect(result, expected);
    });
    test('non-inclusive', () {
      final result = 1.upTo(10);
      final expected = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      expect(result, expected);
    });
  });
}
