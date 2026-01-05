import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:image/image.dart' show arial14;
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
  static const int arrowThickness = 4;
  static const int arrowHeadSize = 12;

  // Text styling constants
  static const int textColorR = 33; // #212529 dark gray/black
  static const int textColorG = 37;
  static const int textColorB = 41;
  static const int textPadding = 10; // Space between screenshot and text

  PngGenerator(this.config, this.layout);

  /// Generates the navigation graph PNG
  Future<bool> generate(String outputPath) async {
    try {
      _logger.info('Generating navigation graph PNG...');
      _logger.info('Getting dimensions...');
      final dimensions = layout.getDimensions();
      _logger.info('Dimensions: ${dimensions.$1}x${dimensions.$2}');
      _logger.info('Creating canvas...');
      final canvas = img.Image(
        width: dimensions.$1,
        height: dimensions.$2,
      );
      _logger.info('Canvas created');

      // Fill background
      img.fill(canvas, color: img.ColorRgb8(248, 249, 250)); // #f8f9fa
      _logger.info('Canvas created: ${dimensions.$1}x${dimensions.$2}');

      // Draw edges first (so they appear behind nodes)
      _logger.info('Drawing ${layout.edges.length} edges...');
      await _drawEdges(canvas);
      _logger.info('Edges drawn');

      // Draw nodes (screenshots)
      _logger.info('Drawing ${layout.nodes.length} nodes...');
      await _drawNodes(canvas);
      _logger.info('Nodes drawn');

      // Save the image
      _logger.info('Encoding PNG...');
      final file = File(outputPath);
      file.parent.createSync(recursive: true);
      final pngBytes = img.encodePng(canvas);
      _logger.info('PNG encoded (${pngBytes.length} bytes), writing to file...');
      await file.writeAsBytes(pngBytes);
      _logger.info('File written');

      _logger.info('✅ Navigation graph saved: $outputPath');
      return true;
    } catch (e) {
      _logger.severe('Error generating PNG: $e');
      return false;
    }
  }

  Future<void> _drawNodes(img.Image canvas) async {
    for (final node in layout.nodes) {
      final filename = config.getFilename(node.screen);
      final screenshotPath = path.join(config.outputDir, filename);
      final file = File(screenshotPath);

      _logger.info('Loading screenshot: $screenshotPath');
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

        // Draw title text below the screenshot
        _drawText(
          canvas,
          node.screen.title,
          node.x + GraphLayout.nodeWidth ~/ 2, // Center horizontally
          node.y + GraphLayout.nodeHeight + textPadding, // Below screenshot
        );
      } catch (e) {
        _logger.warning('Error drawing node ${node.screen.name}: $e');
      }
    }
  }

  void _drawText(img.Image canvas, String text, int centerX, int y) {
    try {
      // Estimate text width (approximately 8 pixels per character for arial14)
      final estimatedWidth = text.length * 8;
      final textX = centerX - estimatedWidth ~/ 2;

      // Create color for text
      final textColor = img.ColorRgb8(textColorR, textColorG, textColorB);

      // Draw text using drawString function
      // Signature: drawString(image, string, {required font, x, y, color, ...})
      img.drawString(
        canvas,
        text,
        font: arial14,
        x: textX,
        y: y,
        color: textColor,
      );
    } catch (e) {
      _logger.warning('Error drawing text "$text": $e');
    }
  }

  Future<void> _drawEdges(img.Image canvas) async {
    // Track drawn edges to avoid duplicates (important for cyclic graphs)
    final drawnEdges = <String>{};

    for (final edge in layout.edges) {
      // Create a unique key for this edge
      final edgeKey = '${edge.from}->${edge.to}';

      // Skip if we've already drawn this edge (handles cycles)
      if (drawnEdges.contains(edgeKey)) {
        _logger.fine('Skipping duplicate edge: $edgeKey');
        continue;
      }

      final fromNode = layout.nodesMap[edge.from];
      final toNode = layout.nodesMap[edge.to];

      if (fromNode == null || toNode == null) {
        _logger.warning('Edge references missing node: ${edge.from} -> ${edge.to}');
        continue;
      }

      // Mark this edge as drawn
      drawnEdges.add(edgeKey);

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

    _logger.info('Drew ${drawnEdges.length} unique edges (${layout.edges.length} total edges in graph)');
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

    // Use image library's drawLine with named parameters
    img.drawLine(
      canvas,
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      color: color,
      thickness: thickness.toDouble(),
    );
  }

  void _drawArrowhead(
    img.Image canvas,
    int x,
    int y,
    int fromX,
    int fromY,
  ) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Calculate angle from start point towards end point (where arrowhead is)
    // This gives us the direction the arrow should point
    final dx = x - fromX;
    final dy = y - fromY;
    final angle = math.atan2(dy, dx);

    // Arrowhead points (135 degrees offset from main line)
    final arrowAngle1 = angle + 2.356; // 135 degrees in radians
    final arrowAngle2 = angle - 2.356; // -135 degrees in radians

    final arrowX1 = (x + arrowHeadSize * math.cos(arrowAngle1)).round();
    final arrowY1 = (y + arrowHeadSize * math.sin(arrowAngle1)).round();
    final arrowX2 = (x + arrowHeadSize * math.cos(arrowAngle2)).round();
    final arrowY2 = (y + arrowHeadSize * math.sin(arrowAngle2)).round();

    // Draw arrowhead lines
    img.drawLine(
      canvas,
      x1: x,
      y1: y,
      x2: arrowX1,
      y2: arrowY1,
      color: color,
      thickness: arrowThickness.toDouble(),
    );
    img.drawLine(
      canvas,
      x1: x,
      y1: y,
      x2: arrowX2,
      y2: arrowY2,
      color: color,
      thickness: arrowThickness.toDouble(),
    );
  }
}
