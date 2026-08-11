import 'package:anyhoo_extension_methods/anyhoo_extension_methods.dart';
import 'package:flutter_test/flutter_test.dart';

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
