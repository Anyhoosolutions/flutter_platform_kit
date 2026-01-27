import 'dart:io';

import 'package:freezed_to_ts/copy_shared_models_to_docs.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late CopySharedModelsToDocs copier;
  late String testDataPath;

  setUpAll(() {
    copier = CopySharedModelsToDocs();
    // Support both package root (dart test) and repo root (dart test tools/freezed_to_ts)
    final inPackage = p.normalize(p.join(Directory.current.path, 'test_data'));
    final fromRepo = p.normalize(p.join(Directory.current.path, 'tools', 'freezed_to_ts', 'test_data'));
    testDataPath = Directory(inPackage).existsSync() ? inPackage : fromRepo;
    expect(Directory(testDataPath).existsSync(), isTrue, reason: 'test_data missing at $inPackage or $fromRepo');
  });

  group('CopySharedModelsToDocs', () {
    test('output starts with title and intro in correct format', () {
      final result = copier.generate(testDataPath);

      expect(result, startsWith('# Shared Models'));
      expect(
        result,
        contains('Dart model definitions extracted from freezed shared models'),
      );
      expect(
        result,
        contains('Use these as a reference for backend and frontend contracts.'),
      );
    });

    test('output has ## sections per source file with ```dart code blocks', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('## address.dart'));
      expect(result, contains('## address_type.dart'));
      expect(result, contains('## recipe_short.dart'));
      expect(result, contains('## user.dart'));
      expect(result, contains('## user_group.dart'));

      final dartBlocks = RegExp(r'```dart\n').allMatches(result);
      final closingFences = RegExp(r'\n```(?!dart)(?:\n|$)').allMatches(result);
      expect(dartBlocks.length, greaterThanOrEqualTo(4), reason: 'test_data has 5 model files');
      expect(dartBlocks.length, equals(closingFences.length), reason: 'Each ```dart block must have a closing ```');
    });

    test('output contains expected Dart for AddressType enum', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('enum AddressType {'));
      expect(result, contains('home, work, other'));
    });

    test('output contains expected Dart for Address', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('class Address {'));
      expect(result, contains('final String id;'));
      expect(result, contains('final String street;'));
      expect(result, contains('final String city;'));
      expect(result, contains('final AddressType addressType;'));
      expect(result, contains('const Address({'));
    });

    test('output contains expected Dart for RecipeShort', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('class RecipeShort {'));
      expect(result, contains('final String? description;'));
      expect(result, contains('final List<String> imageUrls;'));
      expect(result, contains('final List<String> categories;'));
    });

    test('output contains User and UserGroup with imports', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('class User {'));
      expect(result, contains("import 'address.dart';"));
      expect(result, contains('final Address address;'));

      expect(result, contains('class UserGroup {'));
      expect(result, contains("import 'recipe_short.dart';"));
      expect(result, contains('final List<RecipeShort> recipes;'));
    });

    test('output has no freezed parts in code blocks', () {
      final result = copier.generate(testDataPath);
      final codeBlocks = RegExp(r'```dart\n([\s\S]*?)```').allMatches(result);
      for (final m in codeBlocks) {
        final code = m.group(1)!;
        expect(code, isNot(contains('@freezed')), reason: 'code block should not contain @freezed');
        expect(code, isNot(contains('part ')), reason: 'code block should not contain part ');
        expect(code, isNot(contains('with _\$')), reason: 'code block should not contain with _\$');
        expect(code, isNot(contains('fromJson')), reason: 'code block should not contain fromJson');
      }
    });

    test('empty directory produces title and intro only', () {
      final tmp = Directory.systemTemp.createTempSync('copy_shared_models_test_empty');
      try {
        final result = copier.generate(tmp.path);

        expect(result, startsWith('# Shared Models'));
        expect(result, contains('Dart model definitions'));
        expect(result, isNot(contains('## address')));
        expect(result, isNot(contains('```dart')));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    });

    test('directory with no model files produces title and intro only', () {
      final tmp = Directory.systemTemp.createTempSync('copy_shared_models_test_no_models');
      try {
        final noModels = File(p.join(tmp.path, 'helper.dart'));
        noModels.writeAsStringSync('void main() => print("no freezed");');
        final result = copier.generate(tmp.path);

        expect(result, startsWith('# Shared Models'));
        expect(result, isNot(contains('## helper.dart')));
        expect(result, isNot(contains('```dart')));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    });

    test('single file input works', () {
      final singlePath = p.join(testDataPath, 'address_type.dart');
      expect(File(singlePath).existsSync(), isTrue, reason: 'test_data file missing: $singlePath');
      final result = copier.generate(singlePath);

      expect(result, startsWith('# Shared Models'));
      expect(result, contains('## address_type.dart'));
      expect(result, contains('enum AddressType {'));
      expect(result, contains('```dart'));
    });

    test('output has balanced markdown code fences', () {
      final result = copier.generate(testDataPath);

      final openFences = RegExp(r'```dart\n').allMatches(result);
      final closeFences = RegExp(r'\n```(?!dart)(?:\n|$)').allMatches(result);
      expect(openFences.length, equals(closeFences.length), reason: 'Each ```dart block must have a closing ```');
      expect(result, contains('}\n```'));
    });
  });
}
