import 'dart:io';
import 'package:image/image.dart' as img;
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
    File? tempFile;
    try {
      final url = config.getFullUrl(screen);
      final outputPath = path.join(config.outputDir, screen.filename);

      _logger.info('Capturing screenshot for ${screen.name}...');
      _logger.fine('  URL: $url');
      _logger.fine('  Output: $outputPath');

      // Create temp file for Playwright to save to
      final tempDir = Directory.systemTemp;
      tempFile = File(
          path.join(tempDir.path, 'widgetbook_screenshot_${screen.name}_${DateTime.now().millisecondsSinceEpoch}.png'));

      // Use Playwright CLI to capture screenshot to temp file
      // Note: Omitting --full-page means we capture only the viewport (default behavior)
      final result = await Process.run(
        'playwright',
        [
          'screenshot',
          url,
          tempFile.path,
          '--wait-for-timeout=3000', // Wait 3 seconds for page to load
        ],
        runInShell: true,
      );

      if (result.exitCode != 0) {
        _logger.warning(
          'Failed to capture screenshot for ${screen.name}: ${result.stderr}',
        );
        return false;
      }

      // Verify temp file was created
      if (!tempFile.existsSync()) {
        _logger.warning('Screenshot temp file not created: ${tempFile.path}');
        return false;
      }

      // Crop the screenshot
      final cropSuccess = await _cropScreenshot(tempFile, outputPath);
      if (!cropSuccess) {
        _logger.warning('Failed to crop screenshot for ${screen.name}');
        return false;
      }

      _logger.info('✅ Captured and cropped: ${screen.filename}');
      return true;
    } catch (e) {
      _logger.warning('Error capturing screenshot for ${screen.name}: $e');
      return false;
    } finally {
      // Clean up temp file
      try {
        if (tempFile != null && tempFile.existsSync()) {
          await tempFile.delete();
        }
      } catch (e) {
        _logger.fine('Failed to delete temp file: $e');
      }
    }
  }

  Future<bool> _cropScreenshot(File inputFile, String outputPath) async {
    try {
      // Read the image
      final imageBytes = await inputFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        _logger.warning('Failed to decode image: ${inputFile.path}');
        return false;
      }

      final geometry = config.cropGeometry;

      // Verify crop bounds
      if (geometry.xOffset + geometry.width > image.width || geometry.yOffset + geometry.height > image.height) {
        _logger.warning(
          'Crop geometry exceeds image bounds. Image: ${image.width}x${image.height}, '
          'Crop: ${geometry.width}x${geometry.height}+${geometry.xOffset}+${geometry.yOffset}',
        );
        // Use available bounds instead
        final maxWidth = image.width - geometry.xOffset;
        final maxHeight = image.height - geometry.yOffset;
        if (maxWidth <= 0 || maxHeight <= 0) {
          _logger.warning('Invalid crop geometry for image size');
          return false;
        }
      }

      // Crop the image
      final cropped = img.copyCrop(
        image,
        x: geometry.xOffset,
        y: geometry.yOffset,
        width: geometry.width > image.width - geometry.xOffset ? image.width - geometry.xOffset : geometry.width,
        height: geometry.height > image.height - geometry.yOffset ? image.height - geometry.yOffset : geometry.height,
      );

      // Save the cropped image
      final outputFile = File(outputPath);
      outputFile.parent.createSync(recursive: true);
      final pngBytes = img.encodePng(cropped);
      await outputFile.writeAsBytes(pngBytes);

      return true;
    } catch (e) {
      _logger.warning('Error cropping screenshot: $e');
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
