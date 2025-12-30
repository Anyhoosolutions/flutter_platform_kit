import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:widgetbook_screenshots/widgetbook_screenshots.dart';

void main(List<String> arguments) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final str = '${record.level.name}: ${record.message}';
    // ignore: avoid_print
    print(str);
  });

  final parser = ArgParser()
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Path to JSON config file',
      mandatory: true,
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output path for navigation graph PNG (default: ./navigation_graph.png)',
      defaultsTo: './navigation_graph.png',
    )
    ..addFlag(
      'skip-screenshots',
      help: 'Skip screenshot capture (use existing screenshots)',
      defaultsTo: false,
    );

  final argResults = parser.parse(arguments);

  final configPath = argResults['config'] as String;
  final outputPath = argResults['output'] as String;
  final skipScreenshots = argResults['skip-screenshots'] as bool;

  // Load config
  final logger = Logger('main');
  logger.info('Loading config from: $configPath');

  Config config;
  try {
    config = Config.fromJsonFile(configPath);
  } catch (e) {
    logger.severe('Failed to load config: $e');
    exit(1);
  }

  logger.info('Widgetbook URL: ${config.widgetbookUrl}');
  logger.info('Output directory: ${config.outputDir}');
  logger.info('Screens: ${config.screens.length}');

  // Capture screenshots
  if (!skipScreenshots) {
    logger.info('\n📸 Capturing screenshots...');
    final capturer = ScreenshotCapturer(config);
    final success = await capturer.captureAll();
    if (!success) {
      logger.warning('Some screenshots failed to capture. Continuing anyway...');
    }
  } else {
    logger.info('⏭️  Skipping screenshot capture');
  }

  // Generate navigation graph
  logger.info('\n📊 Generating navigation graph...');
  final layout = GraphLayout(config);
  final generator = PngGenerator(config, layout);
  final success = await generator.generate(outputPath);

  if (success) {
    logger.info('\n✅ Done! Navigation graph saved to: $outputPath');
    exit(0);
  } else {
    logger.severe('\n❌ Failed to generate navigation graph');
    exit(1);
  }
}
