import 'dart:io';

import 'package:path/path.dart' as path;

import 'test_extractor.dart';

/// Result of scanning: categorized and grouped test files with extracted tests.
class ScanResult {
  ScanResult({
    required this.flutterUnit,
    required this.patrolIntegration,
    required this.firebaseFunctions,
    required this.firestoreRules,
  });

  final Map<String, List<TestFileEntry>> flutterUnit;
  final Map<String, List<TestFileEntry>> patrolIntegration;
  final Map<String, List<TestFileEntry>> firebaseFunctions;
  final Map<String, List<TestFileEntry>> firestoreRules;

  bool get isEmpty =>
      flutterUnit.isEmpty &&
      patrolIntegration.isEmpty &&
      firebaseFunctions.isEmpty &&
      firestoreRules.isEmpty;
}

/// Scans a project directory for tests and categorizes them by type and group.
class TestScanner {
  TestScanner({
    required this.projectRoot,
    this.patrolTestDirectory = 'patrol_test',
  });

  final String projectRoot;
  final String patrolTestDirectory;

  static const _excludedSegments = {'build', '.dart_tool', 'node_modules'};

  /// Scans the project and returns categorized test files.
  Future<ScanResult> scan() async {
    final rootDir = Directory(projectRoot);
    if (!await rootDir.exists()) {
      throw ArgumentError('Project root does not exist: $projectRoot');
    }

    final flutterUnit = <String, List<TestFileEntry>>{};
    final patrolIntegration = <String, List<TestFileEntry>>{};
    final firebaseFunctions = <String, List<TestFileEntry>>{};
    final firestoreRules = <String, List<TestFileEntry>>{};

    await for (final entity in rootDir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;

      final relativePath = path.relative(entity.path, from: projectRoot);
      if (_isExcluded(relativePath)) continue;

      final normalized = relativePath.replaceAll(r'\', '/');
      final fullPath = path.join(projectRoot, normalized);

      // Flutter unit/widget tests
      if (_isFlutterUnitTest(normalized)) {
        final group = _groupForFlutterTest(normalized);
        final entry = await _extractDartTests(fullPath, normalized);
        flutterUnit.putIfAbsent(group, () => []).add(entry);
        continue;
      }

      // Patrol integration tests
      if (_isPatrolTest(normalized)) {
        final group = _groupForPatrolTest(normalized);
        final entry = await _extractDartTests(fullPath, normalized);
        patrolIntegration.putIfAbsent(group, () => []).add(entry);
        continue;
      }

      // Firestore rules tests (Node.js describe/test)
      if (_isFirestoreRulesTest(normalized)) {
        final group = _groupForNodeTest(normalized);
        final entry = await _extractNodeTests(fullPath, normalized);
        firestoreRules.putIfAbsent(group, () => []).add(entry);
        continue;
      }

      // Firebase Functions tests
      if (_isFirebaseFunctionsTest(normalized)) {
        final group = _groupForNodeTest(normalized);
        final entry = await _extractNodeTests(fullPath, normalized);
        firebaseFunctions.putIfAbsent(group, () => []).add(entry);
        continue;
      }
    }

    // Sort file lists within each group (by file path)
    for (final list in flutterUnit.values) {
      list.sort((a, b) => a.filePath.compareTo(b.filePath));
    }
    for (final list in patrolIntegration.values) {
      list.sort((a, b) => a.filePath.compareTo(b.filePath));
    }
    for (final list in firebaseFunctions.values) {
      list.sort((a, b) => a.filePath.compareTo(b.filePath));
    }
    for (final list in firestoreRules.values) {
      list.sort((a, b) => a.filePath.compareTo(b.filePath));
    }

    return ScanResult(
      flutterUnit: flutterUnit,
      patrolIntegration: patrolIntegration,
      firebaseFunctions: firebaseFunctions,
      firestoreRules: firestoreRules,
    );
  }

  bool _isExcluded(String relativePath) {
    final segments = path.split(relativePath);
    return segments.any((s) => _excludedSegments.contains(s.toLowerCase()));
  }

  bool _isFlutterUnitTest(String path) {
    return path.endsWith('_test.dart') &&
        (path.startsWith('test/') ||
            path.contains('/test/') && _isInKnownPackage(path));
  }

  bool _isInKnownPackage(String path) {
    return path.startsWith('packages/') ||
        path.startsWith('tools/') ||
        path.startsWith('scripts/');
  }

  bool _isPatrolTest(String path) {
    return path.endsWith('_test.dart') &&
        path.startsWith('$patrolTestDirectory/');
  }

  bool _isFirebaseFunctionsTest(String path) {
    if (!path.startsWith('functions/')) return false;
    return path.endsWith('.test.ts') || path.endsWith('.spec.ts');
  }

  bool _isFirestoreRulesTest(String path) {
    return path.endsWith('.rules.test.ts') ||
        path.contains('firestore') &&
            (path.endsWith('.test.ts') || path.endsWith('.spec.ts'));
  }

  String _groupForFlutterTest(String path) {
    if (path.startsWith('packages/')) {
      final rest = path.substring('packages/'.length);
      final pkg = rest.split('/').first;
      return 'packages/$pkg';
    }
    if (path.startsWith('tools/')) {
      final rest = path.substring('tools/'.length);
      final tool = rest.split('/').first;
      return 'tools/$tool';
    }
    if (path.startsWith('scripts/')) {
      final rest = path.substring('scripts/'.length);
      final script = rest.split('/').first;
      return 'scripts/$script';
    }
    if (path.startsWith('test/')) {
      return '(root)';
    }
    return '(root)';
  }

  String _groupForPatrolTest(String path) {
    return '(root)';
  }

  String _groupForNodeTest(String filePath) {
    if (filePath.startsWith('functions/')) {
      return 'functions';
    }
    final dir = path.dirname(filePath);
    return dir.isEmpty ? '(root)' : dir;
  }

  Future<TestFileEntry> _extractDartTests(String fullPath, String relativePath) async {
    try {
      final file = File(fullPath);
      final content = await file.readAsString();
      return TestExtractor.extractFromDart(relativePath, content);
    } catch (_) {
      return TestFileEntry(filePath: relativePath, tests: []);
    }
  }

  Future<TestFileEntry> _extractNodeTests(String fullPath, String relativePath) async {
    try {
      final file = File(fullPath);
      final content = await file.readAsString();
      return TestExtractor.extractFromNode(relativePath, content);
    } catch (_) {
      return TestFileEntry(filePath: relativePath, tests: []);
    }
  }
}
