import 'dart:io';

import 'package:freezed_to_ts/freezed_to_ts.dart';
import 'package:path/path.dart' as p;

/// Copies shared model information (as TypeScript) from Dart freezed files
/// into a Markdown documentation file.
class CopySharedModelsToDocs {
  static const _excludeSuffixes = ['.freezed.dart', '.g.dart'];

  final FreezedToTsConverter _converter = FreezedToTsConverter();

  /// Generates a Markdown document containing TypeScript definitions for all
  /// freezed models and enums found under [inputPath] (file or directory).
  ///
  /// Returns the generated Markdown content.
  String generate(String inputPath) {
    final files = _collectDartFiles(inputPath);
    if (files.isEmpty) return _wrapMarkdown([]);

    // Learn all models first (handles cross-file references)
    for (final file in files) {
      final content = File(file).readAsStringSync();
      if (_hasModels(content)) _converter.learn(content);
    }

    final entries = <_DocEntry>[];
    for (final file in files) {
      final content = File(file).readAsStringSync();
      if (!_hasModels(content)) continue;

      final ts = _converter.convert(content);
      if (ts.trim().isEmpty) continue;

      final basename = p.basename(file);
      entries.add(_DocEntry(sourceFile: basename, tsContent: ts));
    }

    return _wrapMarkdown(entries);
  }

  List<String> _collectDartFiles(String inputPath) {
    final f = File(inputPath);
    final d = Directory(inputPath);
    if (f.existsSync() && f.path.endsWith('.dart')) {
      return _isGenerated(f.path) ? [] : [f.path];
    }
    if (d.existsSync()) {
      final list = d
          .listSync(recursive: true)
          .whereType<File>()
          .map((e) => e.path)
          .where((path) => path.endsWith('.dart') && !_isGenerated(path))
          .toList();
      list.sort();
      return list;
    }
    return [];
  }

  bool _isGenerated(String path) {
    return _excludeSuffixes.any((s) => path.endsWith(s));
  }

  bool _hasModels(String content) {
    return content.contains('@freezed') || content.contains('enum ');
  }

  String _wrapMarkdown(List<_DocEntry> entries) {
    final buf = StringBuffer();
    buf.writeln('# Shared Models');
    buf.writeln();
    buf.writeln(
        'TypeScript definitions generated from Dart freezed shared models. ');
    buf.writeln('Use these as a reference for backend and frontend contracts.');
    buf.writeln();

    for (final e in entries) {
      buf.writeln('## ${e.sourceFile}');
      buf.writeln();
      buf.writeln('```typescript');
      buf.write(e.tsContent.trim());
      buf.writeln();
      buf.writeln('```');
      buf.writeln();
    }

    return buf.toString().trimRight();
  }
}

class _DocEntry {
  final String sourceFile;
  final String tsContent;

  _DocEntry({required this.sourceFile, required this.tsContent});
}
