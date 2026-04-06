import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:widgetbook_screenshots/widgetbook_screenshots.dart';

void main(List<String> arguments) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final str = '${record.level.name}: ${record.message}';
    // ignore: avoid_print
    print(str);
  });

  final parser = ArgParser(allowTrailingOptions: true)
    ..addOption('port', help: 'Widgetbook port', defaultsTo: '45678')
    ..addOption('device', help: 'Device knob value')
    ..addOption(
      'orientation',
      help: 'Orientation knob value',
      allowed: ['portrait', 'landscape'],
    )
    ..addOption(
      'theme-mode',
      help: 'Theme mode knob value',
      allowed: ['light', 'dark', 'system'],
    )
    ..addOption(
      'output-dir',
      help: 'Directory for captured screenshots',
      defaultsTo: './screenshots',
    )
    ..addOption('crop-width', help: 'Crop width in pixels')
    ..addOption('crop-height', help: 'Crop height in pixels')
    ..addOption('crop-x-offset', help: 'Crop x-offset in pixels')
    ..addOption('crop-y-offset', help: 'Crop y-offset in pixels')
    ..addOption(
      'corner-radius',
      help: 'Rounded corner radius in pixels (0 disables transparency mask)',
    )
    ..addFlag(
      'skip-existing-screenshots',
      help: 'Skip screenshot capture if file already exists (capture only missing screenshots)',
      defaultsTo: false,
    );

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    _printUsageAndExit(parser, error: e.toString());
    return;
  }

  final portValue = int.tryParse(argResults['port'] as String);
  if (portValue == null || portValue <= 0) {
    _printUsageAndExit(parser, error: 'Invalid --port value. Must be a positive integer.');
    return;
  }
  final defaultCropGeometry = CropGeometry.fromJson(null);
  final cropWidth = _parseIntOption(
    parser: parser,
    argResults: argResults,
    name: 'crop-width',
    defaultValue: defaultCropGeometry.width,
    mustBePositive: true,
  );
  final cropHeight = _parseIntOption(
    parser: parser,
    argResults: argResults,
    name: 'crop-height',
    defaultValue: defaultCropGeometry.height,
    mustBePositive: true,
  );
  final cropXOffset = _parseIntOption(
    parser: parser,
    argResults: argResults,
    name: 'crop-x-offset',
    defaultValue: defaultCropGeometry.xOffset,
    mustBePositive: false,
  );
  final cropYOffset = _parseIntOption(
    parser: parser,
    argResults: argResults,
    name: 'crop-y-offset',
    defaultValue: defaultCropGeometry.yOffset,
    mustBePositive: false,
  );
  if (cropWidth == null || cropHeight == null || cropXOffset == null || cropYOffset == null) {
    return;
  }
  final cornerRadius = _parseIntOption(
    parser: parser,
    argResults: argResults,
    name: 'corner-radius',
    defaultValue: 0,
    mustBePositive: false,
  );
  if (cornerRadius == null) {
    return;
  }

  final outputDir = argResults['output-dir'] as String;
  final storyPaths = argResults.rest;
  if (storyPaths.isEmpty) {
    _printUsageAndExit(
      parser,
      error: 'Provide at least one story path as positional input.',
    );
    return;
  }

  final config = Config(
    widgetbookUrl: 'http://localhost:$portValue',
    outputDir: outputDir,
    screens: storyPaths.map(_screenFromPath).toList(),
    cropGeometry: CropGeometry(
      width: cropWidth,
      height: cropHeight,
      xOffset: cropXOffset,
      yOffset: cropYOffset,
    ),
    deviceName: argResults['device'] as String?,
    orientation: argResults['orientation'] as String?,
    themeMode: argResults['theme-mode'] as String?,
    cornerRadius: cornerRadius,
  );
  final skipExistingScreenshots = argResults['skip-existing-screenshots'] as bool;

  final logger = Logger('main');
  logger.info('Widgetbook URL: ${config.widgetbookUrl}');
  logger.info('Output directory: ${config.outputDir}');
  logger.info('Screens: ${config.screens.length}');
  if (config.deviceName != null) {
    logger.info('Device: ${config.deviceName}');
  }
  if (config.orientation != null) {
    logger.info('Orientation: ${config.orientation}');
  }
  if (config.themeMode != null) {
    logger.info('Theme mode: ${config.themeMode}');
  }
  logger.info(
    'Crop geometry: ${config.cropGeometry.width}x${config.cropGeometry.height}'
    '+${config.cropGeometry.xOffset}+${config.cropGeometry.yOffset}',
  );
  if (config.cornerRadius > 0) {
    logger.info('Corner radius: ${config.cornerRadius}px');
  }

  logger.info('\n📸 Capturing screenshots...');
  final capturer = ScreenshotCapturer(config, skipExisting: skipExistingScreenshots);
  final success = await capturer.captureAll();
  if (success) {
    logger.info('\n✅ Done! Screenshots saved to: ${config.outputDir}');
    exit(0);
  } else {
    logger.severe('\n❌ Some screenshots failed to capture');
    exit(1);
  }
}

void _printUsageAndExit(ArgParser parser, {String? error}) {
  if (error != null) {
    stderr.writeln('Error: $error');
    stderr.writeln('');
  }
  stderr.writeln('Usage: widgetbook_screenshots [options] <story-path> [more-story-paths]');
  stderr.writeln(parser.usage);
  exit(64);
}

Screen _screenFromPath(String storyPath) {
  final trimmedPath = storyPath.trim();
  final withoutLeadingSlash = trimmedPath.startsWith('/')
      ? trimmedPath.substring(1)
      : trimmedPath;
  final slug = withoutLeadingSlash
      .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '')
      .toLowerCase();
  final safeSlug = slug.isEmpty ? 'story' : slug;

  return Screen(
    name: safeSlug,
    title: safeSlug,
    path: trimmedPath,
    navigatesTo: const [],
  );
}

int? _parseIntOption({
  required ArgParser parser,
  required ArgResults argResults,
  required String name,
  required int defaultValue,
  required bool mustBePositive,
}) {
  final rawValue = argResults[name] as String?;
  if (rawValue == null) {
    return defaultValue;
  }
  final parsed = int.tryParse(rawValue);
  final isValid = parsed != null && (mustBePositive ? parsed > 0 : parsed >= 0);
  if (!isValid) {
    final expectation = mustBePositive ? 'a positive integer' : 'a non-negative integer';
    _printUsageAndExit(parser, error: 'Invalid --$name value. Must be $expectation.');
    return null;
  }
  return parsed;
}
