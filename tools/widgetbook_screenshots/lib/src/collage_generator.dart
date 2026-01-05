import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image/image.dart' show arial14, arial24, arial48;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:widgetbook_screenshots/src/collage_config.dart';
import 'package:widgetbook_screenshots/src/collage_layout.dart';
import 'package:widgetbook_screenshots/src/image_utils.dart';

class CollageGenerator {
  final Logger _logger = Logger('CollageGenerator');
  final CollageConfig config;
  final CollageLayout layout;
  final ImageUtils imageUtils = ImageUtils();

  // Text styling constants
  static const int textColorR = 33; // #212529 dark gray/black
  static const int textColorG = 37;
  static const int textColorB = 41;
  static const int defaultTitlePadding = 10; // Default space between screenshot and text

  CollageGenerator(this.config, this.layout);

  /// Generates the collage PNG
  Future<bool> generate(String outputPath) async {
    try {
      _logger.info('Generating collage PNG...');
      _logger.info('Getting dimensions...');
      final dimensions = layout.getDimensions();
      _logger.info('Dimensions: ${dimensions.width}x${dimensions.height}');
      _logger.info('Creating canvas...');
      final canvas = img.Image(
        width: dimensions.width,
        height: dimensions.height,
      );
      _logger.info('Canvas created');

      // Fill background
      final bgColor = config.getBackgroundColorRgb();
      img.fill(canvas, color: img.ColorRgb8(bgColor.r, bgColor.g, bgColor.b));
      _logger.info('Background filled with color: ${config.backgroundColor}');

      // Draw screenshots
      _logger.info('Drawing ${layout.screens.length} screenshots...');
      await _drawScreenshots(canvas);
      _logger.info('Screenshots drawn');

      // Draw titles if enabled
      if (config.useTitles) {
        _logger.info('Drawing titles...');
        _drawTitles(canvas);
        _logger.info('Titles drawn');
      }

      // Save the image
      _logger.info('Encoding PNG...');
      final file = File(outputPath);
      file.parent.createSync(recursive: true);
      final pngBytes = img.encodePng(canvas);
      _logger.info('PNG encoded (${pngBytes.length} bytes), writing to file...');
      await file.writeAsBytes(pngBytes);
      _logger.info('File written');

      _logger.info('✅ Collage saved: $outputPath');
      return true;
    } catch (e) {
      _logger.severe('Error generating collage: $e');
      return false;
    }
  }

  Future<void> _drawScreenshots(img.Image canvas) async {
    for (final positionedScreen in layout.screens) {
      final filename = config.getFilename(positionedScreen.screen);
      final screenshotPath = path.join(config.outputDir, filename);

      _logger.info('Loading screenshot: $screenshotPath');
      final screenshot = await imageUtils.loadImage(screenshotPath);
      if (screenshot == null) {
        _logger.warning('Screenshot not found: $screenshotPath');
        continue;
      }

      try {
        // Resize screenshot preserving aspect ratio first
        final resizedScreenshot = imageUtils.resizeImage(
          screenshot,
          positionedScreen.width,
          positionedScreen.height,
        );

        // Remove rounded corners AFTER resizing (so radius is relative to final size)
        img.Image processedScreenshot = resizedScreenshot;
        if (config.cornerRadius > 0) {
          final bgColor = config.getBackgroundColorRgb();
          // Scale the radius proportionally to the resize factor
          final scaleFactor = resizedScreenshot.width / screenshot.width;
          final scaledRadius = (config.cornerRadius * scaleFactor).round();
          processedScreenshot = imageUtils.removeRoundedCorners(
            resizedScreenshot,
            scaledRadius,
            bgColor.r,
            bgColor.g,
            bgColor.b,
          );
        }

        // Place screenshot at exact position from position map
        // Center horizontally if screenshot is smaller than target width (due to aspect ratio preservation)
        final offsetX = positionedScreen.x + (positionedScreen.width - processedScreenshot.width) ~/ 2;
        // Use exact y position from position map (no vertical centering)
        final offsetY = positionedScreen.y;

        // Draw screenshot on canvas
        img.compositeImage(
          canvas,
          processedScreenshot,
          dstX: offsetX,
          dstY: offsetY,
        );
      } catch (e) {
        _logger.warning('Error drawing screenshot ${positionedScreen.screen.name}: $e');
      }
    }
  }

  void _drawTitles(img.Image canvas) {
    // Use the position map to get title positions
    final positionMap = layout.getPositionMap();
    for (final positionedScreen in positionMap.values) {
      _drawText(canvas, positionedScreen.screen.title, positionedScreen.titleX, positionedScreen.titleY);
    }
  }

  void _drawText(img.Image canvas, String text, int centerX, int baselineY) {
    try {
      // Select font based on titleFontSize
      img.BitmapFont font;
      int pixelsPerChar;
      switch (config.titleFontSize) {
        case 14:
          font = arial14;
          pixelsPerChar = 8;
          break;
        case 24:
          font = arial24;
          pixelsPerChar = 14;
          break;
        case 48:
          font = arial48;
          pixelsPerChar = 28;
          break;
        default:
          // Default to arial24, or scale if custom size
          if (config.titleFontSize < 20) {
            font = arial14;
            pixelsPerChar = 8;
          } else if (config.titleFontSize < 36) {
            font = arial24;
            pixelsPerChar = 14;
          } else {
            font = arial48;
            pixelsPerChar = 28;
          }
      }

      // Estimate text width
      final estimatedWidth = text.length * pixelsPerChar;
      final textX = centerX - estimatedWidth ~/ 2;

      // Create color for text
      final textColor = img.ColorRgb8(textColorR, textColorG, textColorB);

      // drawString uses baseline Y coordinate. The titleY from position map is already
      // calculated correctly by the layout (accounting for font height when titlePadding = 0)
      final drawY = baselineY;

      // Draw text using drawString function
      img.drawString(
        canvas,
        text,
        font: font,
        x: textX,
        y: drawY,
        color: textColor,
      );
    } catch (e) {
      _logger.warning('Error drawing text "$text": $e');
    }
  }
}
