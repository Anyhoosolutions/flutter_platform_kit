import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:widgetbook_screenshots/src/config.dart';
import 'package:widgetbook_screenshots/src/graph_layout.dart';

class PngGenerator {
  final Logger _logger = Logger('PngGenerator');
  final Config config;
  final GraphLayout layout;

  // Arrow styling constants
  static const int arrowColorR = 108; // #6C757D gray color
  static const int arrowColorG = 117;
  static const int arrowColorB = 125;
  static const int arrowThickness = 2;
  static const int arrowHeadSize = 10;

  PngGenerator(this.config, this.layout);

  /// Generates the navigation graph PNG
  Future<bool> generate(String outputPath) async {
    try {
      _logger.info('Generating navigation graph PNG...');

      final dimensions = layout.getDimensions();
      final canvas = img.Image(
        width: dimensions.$1,
        height: dimensions.$2,
      );

      // Fill background
      img.fill(canvas, color: img.ColorRgb8(248, 249, 250)); // #f8f9fa

      // Draw edges first (so they appear behind nodes)
      await _drawEdges(canvas);

      // Draw nodes (screenshots)
      await _drawNodes(canvas);

      // Save the image
      final file = File(outputPath);
      file.parent.createSync(recursive: true);
      final pngBytes = img.encodePng(canvas);
      await file.writeAsBytes(pngBytes);

      _logger.info('✅ Navigation graph saved: $outputPath');
      return true;
    } catch (e) {
      _logger.severe('Error generating PNG: $e');
      return false;
    }
  }

  Future<void> _drawNodes(img.Image canvas) async {
    for (final node in layout.nodes) {
      final screenshotPath = path.join(config.outputDir, node.screen.filename);
      final file = File(screenshotPath);

      if (!file.existsSync()) {
        _logger.warning('Screenshot not found: $screenshotPath');
        continue;
      }

      try {
        // Load and resize screenshot
        final screenshotBytes = await file.readAsBytes();
        var screenshot = img.decodeImage(screenshotBytes);
        if (screenshot == null) {
          _logger.warning('Failed to decode screenshot: $screenshotPath');
          continue;
        }

        // Resize to fit node dimensions
        screenshot = img.copyResize(
          screenshot,
          width: GraphLayout.nodeWidth,
          height: GraphLayout.nodeHeight,
          interpolation: img.Interpolation.linear,
        );

        // Draw screenshot on canvas
        img.compositeImage(
          canvas,
          screenshot,
          dstX: node.x,
          dstY: node.y,
        );

        // Optionally draw a border around the screenshot
        _drawRect(
          canvas,
          node.x,
          node.y,
          GraphLayout.nodeWidth,
          GraphLayout.nodeHeight,
          arrowColor,
          1,
        );
      } catch (e) {
        _logger.warning('Error drawing node ${node.screen.name}: $e');
      }
    }
  }

  Future<void> _drawEdges(img.Image canvas) async {
    for (final edge in layout.edges) {
      final fromNode = layout.nodesMap[edge.from];
      final toNode = layout.nodesMap[edge.to];

      if (fromNode == null || toNode == null) {
        _logger.warning('Edge references missing node: ${edge.from} -> ${edge.to}');
        continue;
      }

      // Calculate arrow start and end points
      // Start from right edge of source node
      final startX = fromNode.x + GraphLayout.nodeWidth;
      final startY = fromNode.y + GraphLayout.nodeHeight ~/ 2;

      // End at left edge of target node
      final endX = toNode.x;
      final endY = toNode.y + GraphLayout.nodeHeight ~/ 2;

      // Draw arrow line
      _drawLine(canvas, startX, startY, endX, endY, arrowThickness);

      // Draw arrowhead
      _drawArrowhead(canvas, endX, endY, startX, startY);
    }
  }

  void _drawLine(
    img.Image canvas,
    int x1,
    int y1,
    int x2,
    int y2,
    int thickness,
  ) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Use image library's drawLine for better quality
    if (thickness == 1) {
      img.drawLine(canvas, x1, y1, x2, y2, color);
    } else {
      // For thicker lines, draw multiple parallel lines
      for (var i = -thickness ~/ 2; i <= thickness ~/ 2; i++) {
        for (var j = -thickness ~/ 2; j <= thickness ~/ 2; j++) {
          if (i * i + j * j <= (thickness / 2) * (thickness / 2)) {
            img.drawLine(canvas, x1 + i, y1 + j, x2 + i, y2 + j, color);
          }
        }
      }
    }
  }

  void _drawArrowhead(
    img.Image canvas,
    int x,
    int y,
    int fromX,
    int fromY,
  ) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Calculate angle from arrow end point back towards start
    final dx = fromX - x;
    final dy = fromY - y;
    final angle = math.atan2(dy, dx);

    // Arrowhead points (135 degrees offset from main line)
    final arrowAngle1 = angle + 2.356; // 135 degrees in radians
    final arrowAngle2 = angle - 2.356; // -135 degrees in radians

    final arrowX1 = (x + arrowHeadSize * math.cos(arrowAngle1)).round();
    final arrowY1 = (y + arrowHeadSize * math.sin(arrowAngle1)).round();
    final arrowX2 = (x + arrowHeadSize * math.cos(arrowAngle2)).round();
    final arrowY2 = (y + arrowHeadSize * math.sin(arrowAngle2)).round();

    // Draw arrowhead lines
    img.drawLine(canvas, x, y, arrowX1, arrowY1, color);
    img.drawLine(canvas, x, y, arrowX2, arrowY2, color);
  }

  void _drawRect(
    img.Image canvas,
    int x,
    int y,
    int width,
    int height,
    int color,
    int thickness,
  ) {
    final colorRgb = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Top edge
    for (var i = 0; i < thickness; i++) {
      img.drawLine(
        canvas,
        x,
        y + i,
        x + width,
        y + i,
        colorRgb,
      );
    }

    // Bottom edge
    for (var i = 0; i < thickness; i++) {
      img.drawLine(
        canvas,
        x,
        y + height - i - 1,
        x + width,
        y + height - i - 1,
        colorRgb,
      );
    }

    // Left edge
    for (var i = 0; i < thickness; i++) {
      img.drawLine(
        canvas,
        x + i,
        y,
        x + i,
        y + height,
        colorRgb,
      );
    }

    // Right edge
    for (var i = 0; i < thickness; i++) {
      img.drawLine(
        canvas,
        x + width - i - 1,
        y,
        x + width - i - 1,
        y + height,
        colorRgb,
      );
    }
  }
}
