import 'dart:io';

import 'package:path/path.dart' as p;

import 'screenshot_define_keys.dart';
import 'screenshot_png_collector.dart';

/// Result of [runScreenshotKitCli].
class ScreenshotCliResult {
  const ScreenshotCliResult({required this.exitCode});

  final int exitCode;
}

/// Builds argv for `flutter test` with `--dart-define` entries matching [ScreenshotDefineKeys].
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
    out.add('--dart-define=${ScreenshotDefineKeys.logicalWidth}=$width');
  }
  if (height != null) {
    out.add('--dart-define=${ScreenshotDefineKeys.logicalHeight}=$height');
  }
  if (brightness != null && brightness.isNotEmpty) {
    out.add('--dart-define=${ScreenshotDefineKeys.brightness}=$brightness');
  }
  if (devicePixelRatio != null) {
    out.add('--dart-define=${ScreenshotDefineKeys.devicePixelRatio}=$devicePixelRatio');
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

/// Runs `flutter test` and optionally collects PNGs under `goldens/` directories.
Future<ScreenshotCliResult> runScreenshotKitCli({
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
    return ScreenshotCliResult(exitCode: exitCode);
  }

  if (outputDir == null) {
    stderr.writeln('error: --collect requires --output-dir');
    return ScreenshotCliResult(exitCode: 2);
  }

  final sourceRoot = goldensRoot ?? packageDir;
  collectScreenshotPngs(
    sourceRoot: sourceRoot,
    outputDir: outputDir,
    flat: flat,
  );

  return ScreenshotCliResult(exitCode: exitCode);
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
