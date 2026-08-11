import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_extensions_methods/anyhoo_extensions_methods.dart';

void main() {
  test('groupBy', () {
    final list = ['a', 'b', 'c', 'e', 'i'];

    String isVowel(String item) => ['a', 'e', 'i', 'o', 'u'].contains(item) ? 'vowel' : 'consonant';
    final result = list.groupBy(isVowel);
    final expected = {
      'vowel': ['a', 'e', 'i'],
      'consonant': ['b', 'c'],
    };
    expect(result, expected);
  });

  test('distinct', () {
    final list = ['a', 'b', 'a', 'a', 'b', 'c'];

    final result = list.distinct;
    final expected = ['a', 'b', 'c'];
    expect(result, expected);
  });

  test('distinctBy', () {
    final list = [1, 5, 12, 14, 254, 645, 32, 8];

    int length(int item) => item.toString().length;

    final result = list.distinctBy(length);
    final expected = [1, 12, 254];
    expect(result, expected);
  });
}
