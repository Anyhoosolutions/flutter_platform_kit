import 'dart:io';
import 'package:find_tests/test_extractor.dart';

void main() async {
  final path = '/Users/lidholm/git/anyhootrivia/test/features/liveSession/utils/room_code_util_test.dart';
  final content = await File(path).readAsString();
  final result = await TestExtractor.extractFromDart(path, content);
  print('Found ${result.tests.length} tests');
  for (final t in result.tests) {
    print('  - $t');
  }
}
