import 'dart:io';
import 'package:console/toc_generator.dart';

Future<void> main(List<String> arguments) async {
  // Get project root (assuming script is in scripts/console/bin/)
  // Script path: scripts/console/bin/generate_toc.dart
  // Project root: ../../../
  final scriptFile = File(Platform.script.toFilePath());
  final scriptDir = scriptFile.parent; // scripts/console/bin
  final consoleDir = scriptDir.parent; // scripts/console
  final scriptsDir = consoleDir.parent; // scripts
  final projectRoot = scriptsDir.parent; // project root

  final generator = TocGenerator(projectRoot: projectRoot.path);
  await generator.generate();
}
