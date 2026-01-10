import 'dart:io';
import 'package:toc_generator/toc_generator.dart';

Future<void> main(List<String> arguments) async {
  // Get project root (assuming script is in scripts/toc_generator/bin/)
  // Script path: scripts/toc_generator/bin/generate_toc.dart
  // Project root: ../../../
  final scriptFile = File(Platform.script.toFilePath());
  final scriptDir = scriptFile.parent; // scripts/toc_generator/bin
  final tocGeneratorDir = scriptDir.parent; // scripts/toc_generator
  final scriptsDir = tocGeneratorDir.parent; // scripts
  final projectRoot = scriptsDir.parent; // project root

  final generator = TocGenerator(projectRoot: projectRoot.path);
  await generator.generate();
}
