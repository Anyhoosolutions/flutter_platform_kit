import 'dart:io';

import 'package:path/path.dart' as p;

import 'define_keys.dart';
import 'golden_collector.dart';

/// Result of a [runGoldenScreenshotCli] invocation.
class GoldenScreenshotResult {
  const GoldenScreenshotResult({required this.exitCode});

  final int exitCode;
}

/// Expands [args] (e.g. from [ArgParser]) into a [Process] for `flutter test`.
List<String> buildFlutterTestArgs({
  required List<String> testArgs,
  int? width,
  int? height,
  String? brightness,
  double? devicePixelRatio,
  List<String> dartDefines = const [],
  bool updateGoldens = false,
}) {
  final out = <String>['test', ...testArgs];

  if (width != null) {
    out.add('--dart-define=$goldenLogicalWidth=$width');
  }
  if (height != null) {
    out.add('--dart-define=$goldenLogicalHeight=$height');
  }
  if (brightness != null && brightness.isNotEmpty) {
    out.add('--dart-define=$goldenBrightness=$brightness');
  }
  if (devicePixelRatio != null) {
    out.add('--dart-define=$goldenDevicePixelRatio=$devicePixelRatio');
  }
  for (final def in dartDefines) {
    if (def.isEmpty) continue;
    out.add('--dart-define=$def');
  }
  if (updateGoldens) {
    out.add('--update-goldens');
  }

  return out;
}

/// Runs `flutter test` and optionally collects PNGs from `**/goldens/**/*.png`.
Future<GoldenScreenshotResult> runGoldenScreenshotCli({
  required Directory packageDir,
  required List<String> flutterTestArgs,
  bool collect = false,
  Directory? outputDir,
  Directory? goldensRoot,
  bool flat = false,
}) async {
  final flutter = _resolveFlutterExecutable();
  final process = await Process.start(
    flutter,
    flutterTestArgs,
    workingDirectory: packageDir.path,
    mode: ProcessStartMode.inheritStdio,
  );
  final exitCode = await process.exitCode;

  if (exitCode != 0 || !collect) {
    return GoldenScreenshotResult(exitCode: exitCode);
  }

  if (outputDir == null) {
    stderr.writeln('error: --collect requires --output-dir');
    return GoldenScreenshotResult(exitCode: 2);
  }

  final sourceRoot = goldensRoot ?? packageDir;
  collectGoldenPngs(
    sourceRoot: sourceRoot,
    outputDir: outputDir,
    flat: flat,
  );

  return GoldenScreenshotResult(exitCode: exitCode);
}

String _resolveFlutterExecutable() {
  final env = Platform.environment['FLUTTER_ROOT'];
  if (env != null && env.isNotEmpty) {
    final candidate = p.join(env, 'bin', 'flutter');
    if (File(candidate).existsSync()) {
      return candidate;
    }
  }
  return 'flutter';
}
