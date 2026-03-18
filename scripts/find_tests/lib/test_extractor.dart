/// Result of parsing a test file: file path and list of test names (with hierarchy).
class TestFileEntry {
  TestFileEntry({
    required this.filePath,
    required this.tests,
  });

  final String filePath;
  final List<String> tests;
}

/// Extracts group/test names from Dart and Node.js/TypeScript test files.
/// Uses two alternatives so we only stop at the *matching* delimiter:
/// - "..." allows apostrophes (e.g. "doesn't")
/// - '...' allows escapes (e.g. 'doesn\'t')
/// All string delimiters use hex escapes (\x22=" \x27=' \x60=` \x5c=\) to avoid parsing issues.
class TestExtractor {
  static final _dartGroup = RegExp(
      r'group\s*\(\s*(?:"((?:[^\x22\x5c]|\x5c.)*)"|\x27((?:[^\x27\x5c]|\x5c.)*)\x27)');
  static final _dartTest = RegExp(
      r'(?:testWidgets?|patrolTest|blocTest|test)(?:\s*<(?:[^<>]*|<[^>]*>)*>)?\s*\(\s*(?:"((?:[^\x22\x5c]|\x5c.)*)"|\x27((?:[^\x27\x5c]|\x5c.)*)\x27)');
  static final _nodeDescribe = RegExp(
      r'describe\s*\(\s*"((?:[^\x22\x5c]|\x5c.)*)"|\x27((?:[^\x27\x5c]|\x5c.)*)\x27|`((?:[^\x60\x5c]|\x5c.)*)`');
  static final _nodeIt = RegExp(
      r'\bit\s*\(\s*"((?:[^\x22\x5c]|\x5c.)*)"|\x27((?:[^\x27\x5c]|\x5c.)*)\x27|`((?:[^\x60\x5c]|\x5c.)*)`');
  static final _nodeTest = RegExp(
      r'\btest\s*\(\s*"((?:[^\x22\x5c]|\x5c.)*)"|\x27((?:[^\x27\x5c]|\x5c.)*)\x27|`((?:[^\x60\x5c]|\x5c.)*)`');

  /// Extracts tests from a Dart file (group, test, testWidgets, patrolTest).
  static Future<TestFileEntry> extractFromDart(String filePath, String content) async {
    final tests = <String>[];
    final lines = content.split('\n');

    // Collect all group/test matches with their positions for correct ordering
    final matches = <_MatchInfo>[];
    for (final m in _dartGroup.allMatches(content)) {
      final name = m.group(1) ?? m.group(2);
      if (name != null) matches.add(_MatchInfo(m.start, true, name));
    }
    for (final m in _dartTest.allMatches(content)) {
      final name = m.group(1) ?? m.group(2);
      if (name != null) matches.add(_MatchInfo(m.start, false, name));
    }
    matches.sort((a, b) => a.position.compareTo(b.position));

    final groupStack = <_StackItem>[];
    for (final info in matches) {
      final lineStart = content.lastIndexOf('\n', info.position);
      final lineIndex = lineStart < 0 ? 0 : content.substring(0, lineStart).split('\n').length;
      final line = lineIndex < lines.length ? lines[lineIndex] : '';
      final indent = line.length - line.trimLeft().length;

      while (groupStack.isNotEmpty && groupStack.last.indent >= indent) {
        groupStack.removeLast();
      }

      if (info.isGroup) {
        groupStack.add(_StackItem(indent: indent, name: _unescape(info.name)));
      } else {
        final pathParts = groupStack.map((e) => e.name).toList()..add(_unescape(info.name));
        tests.add(pathParts.join(' > '));
      }
    }

    return TestFileEntry(filePath: filePath, tests: tests);
  }

  /// Extracts tests from a Node.js/TypeScript file (describe, it, test).
  static Future<TestFileEntry> extractFromNode(String filePath, String content) async {
    final tests = <String>[];
    final lines = content.split('\n');
    final groupStack = <_StackItem>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final indent = line.length - line.trimLeft().length;

      while (groupStack.isNotEmpty && groupStack.last.indent >= indent) {
        groupStack.removeLast();
      }

      final describeMatch = _nodeDescribe.firstMatch(line);
      if (describeMatch != null) {
        final name = describeMatch.group(1) ?? describeMatch.group(2) ?? describeMatch.group(3)!;
        groupStack.add(_StackItem(indent: indent, name: _unescape(name)));
        continue;
      }

      final itMatch = _nodeIt.firstMatch(line);
      final testMatch = _nodeTest.firstMatch(line);
      final testName = itMatch?.group(1) ?? itMatch?.group(2) ?? itMatch?.group(3) ??
          testMatch?.group(1) ?? testMatch?.group(2) ?? testMatch?.group(3);
      if (testName != null) {
        final pathParts = groupStack.map((e) => e.name).toList()..add(_unescape(testName));
        tests.add(pathParts.join(' > '));
      }
    }

    return TestFileEntry(filePath: filePath, tests: tests);
  }

  static String _unescape(String s) {
    return s.replaceAll(r"\'", "'").replaceAll(r'\"', '"');
  }
}

class _MatchInfo {
  _MatchInfo(this.position, this.isGroup, this.name);
  final int position;
  final bool isGroup;
  final String name;
}

class _StackItem {
  _StackItem({required this.indent, required this.name});
  final int indent;
  final String name;
}
