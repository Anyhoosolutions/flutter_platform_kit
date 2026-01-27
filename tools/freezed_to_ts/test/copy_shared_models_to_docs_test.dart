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
        contains('TypeScript definitions generated from Dart freezed shared models.'),
      );
      expect(
        result,
        contains('Use these as a reference for backend and frontend contracts.'),
      );
    });

    test('output has ## sections per source file with ```typescript code blocks', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('## address.dart'));
      expect(result, contains('## address_type.dart'));
      expect(result, contains('## recipe_short.dart'));
      expect(result, contains('## user.dart'));
      expect(result, contains('## user_group.dart'));

      final tsBlocks = RegExp(r'```typescript\n').allMatches(result);
      // Match ``` only when not part of ```typescript (closing fences); last may have no trailing \n (trimRight)
      final closingFences = RegExp(r'\n```(?!typescript)(?:\n|$)').allMatches(result);
      expect(tsBlocks.length, greaterThanOrEqualTo(4), reason: 'test_data has 5 model files');
      expect(tsBlocks.length, equals(closingFences.length), reason: 'Each ```typescript block must have a closing ```');
    });

    test('output contains expected TypeScript for AddressType enum', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('export enum AddressType {'));
      expect(result, contains('home = "home",'));
      expect(result, contains('work = "work",'));
      expect(result, contains('other = "other",'));
    });

    test('output contains expected TypeScript for Address', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('export interface Address {'));
      expect(result, contains('id: string;'));
      expect(result, contains('street: string;'));
      expect(result, contains('city: string;'));
      expect(result, contains('addressType: AddressType;'));
    });

    test('output contains expected TypeScript for RecipeShort', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('export interface RecipeShort {'));
      expect(result, contains('description: string | null;'));
      expect(result, contains('imageUrls: string[];'));
      expect(result, contains('categories: string[];'));
    });

    test('output contains User and UserGroup with imports', () {
      final result = copier.generate(testDataPath);

      expect(result, contains('export interface User {'));
      expect(result, contains('import type { Address } from "./address";'));
      expect(result, contains('address: Address;'));

      expect(result, contains('export interface UserGroup {'));
      expect(result, contains('import type { RecipeShort } from "./recipe_short";'));
      expect(result, contains('recipes: RecipeShort[];'));
    });

    test('empty directory produces title and intro only', () {
      final tmp = Directory.systemTemp.createTempSync('copy_shared_models_test_empty');
      try {
        final result = copier.generate(tmp.path);

        expect(result, startsWith('# Shared Models'));
        expect(result, contains('TypeScript definitions generated from'));
        expect(result, isNot(contains('## ')));
        expect(result, isNot(contains('```typescript')));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    });

    test('directory with no model files produces title and intro only', () {
      final tmp = Directory.systemTemp.createTempSync('copy_shared_models_test_no_models');
      try {
        final noModels = File(p.join(tmp.path, 'helper.dart'));
        noModels.writeAsStringSync('''
void main() => print("no freezed");
''');
        final result = copier.generate(tmp.path);

        expect(result, startsWith('# Shared Models'));
        expect(result, isNot(contains('## helper.dart')));
        expect(result, isNot(contains('```typescript')));
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
      expect(result, contains('export enum AddressType {'));
      expect(result, contains('```typescript'));
    });

    test('output has balanced markdown code fences', () {
      final result = copier.generate(testDataPath);

      final openFences = RegExp(r'```typescript\n').allMatches(result);
      final closeFences = RegExp(r'\n```(?!typescript)(?:\n|$)').allMatches(result);
      expect(openFences.length, equals(closeFences.length), reason: 'Each ```typescript block must have a closing ```');
      expect(result, contains('}\n```'));
    });
  });
}
