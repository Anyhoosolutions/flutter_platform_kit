import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:find_tests/find_tests.dart';

void main(List<String> arguments) async {
  String? projectRoot;
  String? outputPath;
  var quiet = false;

  for (var i = 0; i < arguments.length; i++) {
    final arg = arguments[i];
    if (arg == '--project-root' && i + 1 < arguments.length) {
      projectRoot = arguments[++i];
    } else if (arg.startsWith('--project-root=')) {
      projectRoot = arg.split('=').sublist(1).join('=').trim();
    } else if (arg == '--output' && i + 1 < arguments.length) {
      outputPath = arguments[++i];
    } else if (arg.startsWith('--output=')) {
      outputPath = arg.split('=').sublist(1).join('=').trim();
    } else if (arg == '--quiet' || arg == '-q') {
      quiet = true;
    } else if (arg == '--help' || arg == '-h') {
      _printUsage();
      exit(0);
    }
  }

  final root = projectRoot ?? path.current;
  final rootDir = Directory(root);
  if (!await rootDir.exists()) {
    stderr.writeln('Error: Project root does not exist: $root');
    exit(1);
  }

  final resolvedRoot = path.absolute(root);

  try {
    final findTests = FindTests(
      projectRoot: resolvedRoot,
      outputPath: outputPath != null
          ? (path.isAbsolute(outputPath)
              ? outputPath
              : path.join(resolvedRoot, outputPath))
          : null,
      quiet: quiet,
    );
    await findTests.run();
  } catch (e, st) {
    stderr.writeln('Error: $e');
    if (!quiet) {
      stderr.writeln(st);
    }
    exit(1);
  }
}

void _printUsage() {
  print('''
Usage: dart run find_tests [options]

Options:
  --project-root=<path>  Root of repo to scan (default: current directory)
  --output=<path>       Output file (default: docs/tests.md)
  --quiet, -q           Minimal output
  --help, -h            Show this help
''');
}
