import 'package:flutter_test/flutter_test.dart';
import 'package:anyhoo_core/utils/string_utils.dart';

void main() {
  group('AnyhooStringUtils', () {
    group('generateRandomString', () {
      test('generates string of correct length', () {
        final result = AnyhooStringUtils.generateRandomString(10);
        expect(result.length, 10);
      });

      test('generates string with default parameters (uppercase, lowercase, numbers)', () {
        final result = AnyhooStringUtils.generateRandomString(100);
        expect(result.length, 100);
        // Should contain at least one uppercase letter
        expect(result.split('').any((char) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(char)), true);
        // Should contain at least one lowercase letter
        expect(result.split('').any((char) => 'abcdefghijklmnopqrstuvwxyz'.contains(char)), true);
        // Should contain at least one number
        expect(result.split('').any((char) => '0123456789'.contains(char)), true);
        // Should contain no special character
        expect(result.split('').any((char) => '!@#%^&*()_-'.contains(char)), false);
      });

      test('generates string with only uppercase letters', () {
        final result = AnyhooStringUtils.generateRandomString(
          50,
          includeUppercase: true,
          includeLowercase: false,
          includeNumbers: false,
          includeSpecial: false,
        );
        expect(result.length, 50);
        expect(result.split('').every((char) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(char)), true);
      });

      test('generates string with only lowercase letters', () {
        final result = AnyhooStringUtils.generateRandomString(
          50,
          includeUppercase: false,
          includeLowercase: true,
          includeNumbers: false,
          includeSpecial: false,
        );
        expect(result.length, 50);
        expect(result.split('').every((char) => 'abcdefghijklmnopqrstuvwxyz'.contains(char)), true);
      });

      test('generates string with only numbers', () {
        final result = AnyhooStringUtils.generateRandomString(
          50,
          includeUppercase: false,
          includeLowercase: false,
          includeNumbers: true,
          includeSpecial: false,
        );
        expect(result.length, 50);
        expect(result.split('').every((char) => '0123456789'.contains(char)), true);
      });

      test('generates string with special characters', () {
        final result = AnyhooStringUtils.generateRandomString(
          100,
          includeUppercase: true,
          includeLowercase: true,
          includeNumbers: true,
          includeSpecial: true,
        );
        expect(result.length, 100);
        // Should contain at least one special character
        expect(result.split('').any((char) => '!@#%^&*()_-'.contains(char)), true);
      });

      test('generates string with only special characters', () {
        final result = AnyhooStringUtils.generateRandomString(
          20,
          includeUppercase: false,
          includeLowercase: false,
          includeNumbers: false,
          includeSpecial: true,
        );
        expect(result.length, 20);
        expect(result.split('').every((char) => '!@#%^&*()_-'.contains(char)), true);
      });

      test('generates different strings on multiple calls', () {
        final result1 = AnyhooStringUtils.generateRandomString(100);
        final result2 = AnyhooStringUtils.generateRandomString(100);
        // Very unlikely to be the same (but technically possible)
        expect(result1.length, 100);
        expect(result2.length, 100);
        expect(result1 != result2, true);
      });

      test('handles length of 0', () {
        final result = AnyhooStringUtils.generateRandomString(0);
        expect(result.length, 0);
        expect(result, '');
      });

      test('handles length of 1', () {
        final result = AnyhooStringUtils.generateRandomString(1);
        expect(result.length, 1);
        expect('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.contains(result), true);
      });

      test('handles very long strings', () {
        final result = AnyhooStringUtils.generateRandomString(10000);
        expect(result.length, 10000);
      });

      test('throws error when all character sets are disabled', () {
        expect(
          () => AnyhooStringUtils.generateRandomString(
            10,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: false,
            includeSpecial: false,
          ),
          throwsA(isA<RangeError>()),
        );
      });
    });
  });
}
