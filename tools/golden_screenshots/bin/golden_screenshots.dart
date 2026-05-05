import 'dart:io';

import 'package:args/args.dart';
import 'package:golden_screenshots/golden_screenshots.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'directory',
      abbr: 'C',
      help: 'Flutter package root (working directory for flutter test)',
      defaultsTo: '.',
    )
    ..addOption(
      'width',
      help: 'Sets --dart-define=$goldenLogicalWidth=<int>',
    )
    ..addOption(
      'height',
      help: 'Sets --dart-define=$goldenLogicalHeight=<int>',
    )
    ..addOption(
      'brightness',
      help: 'Sets --dart-define=$goldenBrightness=light|dark',
      allowed: ['light', 'dark'],
    )
    ..addOption(
      'device-pixel-ratio',
      help: 'Sets --dart-define=$goldenDevicePixelRatio=<double>',
    )
    ..addMultiOption(
      'dart-define',
      help: 'Extra dart-define entries as KEY=value (repeatable)',
      splitCommas: false,
    )
    ..addFlag(
      'update-goldens',
      help: 'Forwards --update-goldens to flutter test',
      defaultsTo: false,
    )
    ..addFlag(
      'collect',
      help: 'After success, copy PNGs from **/goldens/**/*.png under --goldens-root or package',
      defaultsTo: false,
    )
    ..addOption(
      'output-dir',
      help: 'Required with --collect: destination directory for copied PNGs',
    )
    ..addOption(
      'goldens-root',
      help: 'Restrict collection to this directory tree (default: --directory)',
    )
    ..addFlag(
      'flat',
      help: 'With --collect, flatten filenames (basename only); errors on duplicates',
      defaultsTo: false,
    );

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    _printUsage(parser);
    exitCode = 64;
    return;
  }

  final collect = results['collect'] as bool;
  final outputDirPath = results['output-dir'] as String?;
  if (collect && (outputDirPath == null || outputDirPath.isEmpty)) {
    stderr.writeln('error: --collect requires --output-dir');
    _printUsage(parser);
    exitCode = 2;
    return;
  }

  final rest = results.rest;

  final packageDir = Directory(results['directory'] as String);
  if (!packageDir.existsSync()) {
    stderr.writeln('error: directory does not exist: ${packageDir.path}');
    exitCode = 2;
    return;
  }

  final width = int.tryParse(results['width'] as String? ?? '');
  final height = int.tryParse(results['height'] as String? ?? '');
  final dpr = double.tryParse(results['device-pixel-ratio'] as String? ?? '');

  final brightness = results['brightness'] as String?;
  final dartDefines = results['dart-define'] as List<String>;

  final flutterArgs = buildFlutterTestArgs(
    testArgs: rest,
    width: width,
    height: height,
    brightness: brightness,
    devicePixelRatio: dpr,
    dartDefines: dartDefines,
    updateGoldens: results['update-goldens'] as bool,
  );

  final goldensRootPath = results['goldens-root'] as String?;
  final goldensRoot =
      goldensRootPath != null && goldensRootPath.isNotEmpty ? Directory(goldensRootPath) : null;

  final result = await runGoldenScreenshotCli(
    packageDir: packageDir,
    flutterTestArgs: flutterArgs,
    collect: collect,
    outputDir: outputDirPath != null && outputDirPath.isNotEmpty
        ? Directory(outputDirPath)
        : null,
    goldensRoot: goldensRoot,
    flat: results['flat'] as bool,
  );

  exitCode = result.exitCode;
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: golden_screenshots [options] [flutter test arguments...]');
  stdout.writeln('');
  stdout.writeln(
    'Runs "flutter test" with optional dart-defines for golden_test_wrappers.',
  );
  stdout.writeln('');
  stdout.writeln(parser.usage);
}
