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
      help: 'Output path for PNG (default: ./navigation_graph.png for graph mode, ./collage.png for collage mode)',
    )
    ..addOption(
      'mode',
      abbr: 'm',
      help: 'Generation mode: "graph" for navigation graph, "collage" for screenshot collage',
      allowed: ['graph', 'collage'],
      defaultsTo: 'graph',
    )
    ..addFlag(
      'skip-screenshots',
      help: 'Skip screenshot capture (use existing screenshots)',
      defaultsTo: false,
    )
    ..addFlag(
      'skip-existing-screenshots',
      help: 'Skip screenshot capture if file already exists (capture only missing screenshots)',
      defaultsTo: false,
    )
    ..addFlag(
      'dark-mode',
      help: 'Capture screenshots in dark mode (appends dark mode knobs to URL)',
      defaultsTo: false,
    );

  final argResults = parser.parse(arguments);

  final configPath = argResults['config'] as String;
  final mode = argResults['mode'] as String;
  var outputPath = argResults['output'] as String?;
  final skipScreenshots = argResults['skip-screenshots'] as bool;
  final skipExistingScreenshots = argResults['skip-existing-screenshots'] as bool;
  final darkMode = argResults['dark-mode'] as bool;

  // Set default output path if not provided
  outputPath ??= mode == 'collage' ? './collage.png' : './navigation_graph.png';

  // Add "-dark" suffix to output filename if dark mode is enabled
  if (darkMode) {
    final pathParts = outputPath.split('.');
    if (pathParts.length > 1) {
      final extension = pathParts.removeLast();
      final basePath = pathParts.join('.');
      outputPath = '$basePath-dark.$extension';
    } else {
      outputPath = '$outputPath-dark';
    }
  }

  // Load config
  final logger = Logger('main');
  logger.info('Loading config from: $configPath');
  logger.info('Mode: $mode');

  if (mode == 'collage') {
    // Collage mode
    CollageConfig config;
    try {
      config = CollageConfig.fromJsonFile(configPath, darkMode: darkMode);
    } catch (e) {
      logger.severe('Failed to load collage config: $e');
      exit(1);
    }

    logger.info('Widgetbook URL: ${config.widgetbookUrl}');
    logger.info('Output directory: ${config.outputDir}');
    logger.info('Screens: ${config.screens.length}');
    logger.info('Scale: ${config.scale}');
    logger.info('Background color: ${config.backgroundColor}');
    logger.info('Use titles: ${config.useTitles}');
    if (darkMode) {
      logger.info('Dark mode: enabled');
    }

    // Capture screenshots
    if (!skipScreenshots) {
      logger.info('\n📸 Capturing screenshots...');
      // For collage, we need to capture screenshots using the same capturer
      // but we need to adapt it. For now, let's create a temporary Config
      // to reuse ScreenshotCapturer, or we could make ScreenshotCapturer work with both
      // Let's create a temporary Config for screenshot capture
      final tempConfig = Config(
        widgetbookUrl: config.widgetbookUrl,
        outputDir: config.outputDir,
        screens: config.screens
            .map((s) => Screen(
                  name: s.name,
                  title: s.title,
                  path: s.path,
                  navigatesTo: [],
                ))
            .toList(),
        cropGeometry: config.cropGeometry,
        darkMode: darkMode,
      );
      final capturer = ScreenshotCapturer(tempConfig, skipExisting: skipExistingScreenshots);
      final success = await capturer.captureAll();
      if (!success) {
        logger.warning('Some screenshots failed to capture. Continuing anyway...');
      }
    } else {
      logger.info('⏭️  Skipping screenshot capture');
    }

    // Generate collage
    logger.info('\n🖼️  Generating collage...');
    logger.info('Creating collage layout...');
    final layout = CollageLayout(config);
    logger.info('Collage layout created, creating collage generator...');
    final generator = CollageGenerator(config, layout);
    logger.info('Collage generator created, generating PNG...');
    final success = await generator.generate(outputPath);

    if (success) {
      logger.info('\n✅ Done! Collage saved to: $outputPath');
      exit(0);
    } else {
      logger.severe('\n❌ Failed to generate collage');
      exit(1);
    }
  } else {
    // Graph mode (default)
    Config config;
    try {
      config = Config.fromJsonFile(configPath, darkMode: darkMode);
    } catch (e) {
      logger.severe('Failed to load config: $e');
      exit(1);
    }

    logger.info('Widgetbook URL: ${config.widgetbookUrl}');
    logger.info('Output directory: ${config.outputDir}');
    logger.info('Screens: ${config.screens.length}');
    if (darkMode) {
      logger.info('Dark mode: enabled');
    }

    // Capture screenshots
    if (!skipScreenshots) {
      logger.info('\n📸 Capturing screenshots...');
      final capturer = ScreenshotCapturer(config, skipExisting: skipExistingScreenshots);
      final success = await capturer.captureAll();
      if (!success) {
        logger.warning('Some screenshots failed to capture. Continuing anyway...');
      }
    } else {
      logger.info('⏭️  Skipping screenshot capture');
    }

    // Generate navigation graph
    logger.info('\n📊 Generating navigation graph...');
    logger.info('Creating graph layout...');
    final layout = GraphLayout(config);
    logger.info('Graph layout created, creating PNG generator...');
    final generator = PngGenerator(config, layout);
    logger.info('PNG generator created, generating PNG...');
    final success = await generator.generate(outputPath);

    if (success) {
      logger.info('\n✅ Done! Navigation graph saved to: $outputPath');
      exit(0);
    } else {
      logger.severe('\n❌ Failed to generate navigation graph');
      exit(1);
    }
  }
}
