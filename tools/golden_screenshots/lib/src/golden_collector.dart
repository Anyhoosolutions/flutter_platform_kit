import 'dart:io';

import 'package:path/path.dart' as p;

/// Lists PNG files under any directory segment named `goldens`.
Iterable<File> findGoldenPngs(Directory root) sync* {
  if (!root.existsSync()) {
    return;
  }
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (!path.endsWith('.png')) continue;
    final segments = p.split(path);
    if (segments.contains('goldens')) {
      yield entity;
    }
  }
}

/// Copies golden PNGs into [outputDir].
///
/// When [flat] is true, uses basename only; duplicate names throw [StateError].
void collectGoldenPngs({
  required Directory sourceRoot,
  required Directory outputDir,
  required bool flat,
}) {
  outputDir.createSync(recursive: true);
  final usedBasenames = <String>{};
  for (final file in findGoldenPngs(sourceRoot)) {
    late final String destPath;
    if (flat) {
      final name = p.basename(file.path);
      if (!usedBasenames.add(name)) {
        throw StateError(
          'Duplicate basename "$name" with --flat; rename sources or disable --flat.',
        );
      }
      destPath = p.join(outputDir.path, name);
    } else {
      final relative = p.relative(file.path, from: sourceRoot.path);
      destPath = p.join(outputDir.path, relative);
    }
    File(destPath).parent.createSync(recursive: true);
    file.copySync(destPath);
  }
}
