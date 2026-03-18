import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'test_scanner.dart';

/// Generates a markdown summary of all tests in a Flutter project.
class FindTests {
  FindTests({
    required this.projectRoot,
    String? outputPath,
    this.quiet = false,
  }) : outputPath = outputPath ?? path.join(projectRoot, 'docs', 'tests.md');

  final String projectRoot;
  final String outputPath;
  final bool quiet;

  /// Runs the scan and writes the markdown output.
  Future<void> run() async {
    final patrolTestDir = await _readPatrolTestDirectory();
    final scanner = TestScanner(
      projectRoot: projectRoot,
      patrolTestDirectory: patrolTestDir,
    );

    if (!quiet) {
      print('🔍 Scanning for tests in $projectRoot...');
    }

    final result = await scanner.scan();

    if (result.isEmpty) {
      if (!quiet) {
        print('⚠️  No tests found.');
      }
      await _writeMarkdown(ScanResult(
        flutterUnit: {},
        patrolIntegration: {},
        firebaseFunctions: {},
        firestoreRules: {},
      ));
      return;
    }

    if (!quiet) {
      final total = result.flutterUnit.values.fold<int>(0, (s, l) => s + l.length) +
          result.patrolIntegration.values.fold<int>(0, (s, l) => s + l.length) +
          result.firebaseFunctions.values.fold<int>(0, (s, l) => s + l.length) +
          result.firestoreRules.values.fold<int>(0, (s, l) => s + l.length);
      print('✅ Found $total test files');
    }

    await _writeMarkdown(result);

    if (!quiet) {
      print('📄 Wrote $outputPath');
    }
  }

  Future<String> _readPatrolTestDirectory() async {
    try {
      final pubspecFile = File(path.join(projectRoot, 'pubspec.yaml'));
      if (!await pubspecFile.exists()) return 'patrol_test';

      final content = await pubspecFile.readAsString();
      final yaml = loadYaml(content);

      if (yaml is YamlMap) {
        final patrol = yaml['patrol'];
        if (patrol is YamlMap) {
          final testDir = patrol['test_directory'];
          if (testDir is String) return testDir;
        }
      }
    } catch (_) {
      // Ignore parse errors, use default
    }
    return 'patrol_test';
  }

  Future<void> _writeMarkdown(ScanResult result) async {
    final buffer = StringBuffer();
    buffer.writeln('# Tests');
    buffer.writeln();
    buffer.writeln('Overview of test suites in this project.');
    buffer.writeln();

    _writeSection(
      buffer,
      'Flutter Unit/Widget Tests',
      result.flutterUnit,
    );

    _writeSection(
      buffer,
      'Patrol Integration Tests',
      result.patrolIntegration,
    );

    _writeSection(
      buffer,
      'Firebase Functions Tests',
      result.firebaseFunctions,
    );

    _writeSection(
      buffer,
      'Firestore Rules Tests',
      result.firestoreRules,
    );

    final outputFile = File(outputPath);
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(buffer.toString());
  }

  void _writeSection(
    StringBuffer buffer,
    String title,
    Map<String, List<String>> groups,
  ) {
    buffer.writeln('## $title');
    buffer.writeln();

    if (groups.isEmpty) {
      buffer.writeln('*No tests found.*');
      buffer.writeln();
      return;
    }

    final sortedGroups = groups.keys.toList()..sort();
    for (final group in sortedGroups) {
      buffer.writeln('### $group');
      for (final file in groups[group]!) {
        buffer.writeln('- `$file`');
      }
      buffer.writeln();
    }
  }
}
