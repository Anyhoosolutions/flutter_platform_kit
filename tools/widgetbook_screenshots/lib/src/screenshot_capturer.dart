import 'dart:io';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:widgetbook_screenshots/src/config.dart';

class ScreenshotCapturer {
  final Logger _logger = Logger('ScreenshotCapturer');
  final Config config;

  ScreenshotCapturer(this.config);

  /// Captures screenshots for all screens using Playwright CLI
  Future<bool> captureAll() async {
    _logger.info('Starting screenshot capture for ${config.screens.length} screens');

    // Check if Playwright is available
    if (!await _isPlaywrightAvailable()) {
      _logger.severe(
        'Playwright CLI not found. Please install Playwright:\n'
        '  npm install -g playwright\n'
        '  playwright install chromium',
      );
      return false;
    }

    // Create output directory
    final outputDir = Directory(config.outputDir);
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    int successCount = 0;
    for (final screen in config.screens) {
      final success = await _captureScreen(screen);
      if (success) {
        successCount++;
      }
    }

    _logger.info('Captured $successCount/${config.screens.length} screenshots');
    return successCount == config.screens.length;
  }

  Future<bool> _captureScreen(Screen screen) async {
    try {
      final url = config.getFullUrl(screen);
      final outputPath = path.join(config.outputDir, screen.filename);

      _logger.info('Capturing screenshot for ${screen.name}...');
      _logger.fine('  URL: $url');
      _logger.fine('  Output: $outputPath');

      // Use Playwright CLI to capture screenshot
      final result = await Process.run(
        'playwright',
        [
          'screenshot',
          url,
          outputPath,
          '--wait-for-timeout=3000', // Wait 3 seconds for page to load
          '--full-page=false', // Only capture viewport
        ],
        runInShell: true,
      );

      if (result.exitCode != 0) {
        _logger.warning(
          'Failed to capture screenshot for ${screen.name}: ${result.stderr}',
        );
        return false;
      }

      // Verify file was created
      final file = File(outputPath);
      if (!file.existsSync()) {
        _logger.warning('Screenshot file not created: $outputPath');
        return false;
      }

      _logger.info('✅ Captured: ${screen.filename}');
      return true;
    } catch (e) {
      _logger.warning('Error capturing screenshot for ${screen.name}: $e');
      return false;
    }
  }

  Future<bool> _isPlaywrightAvailable() async {
    try {
      final result = await Process.run(
        'playwright',
        ['--version'],
        runInShell: true,
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
}
