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

      // Draw back-edge arrows to indicate cycles
      _logger.info('Drawing back-edge arrows...');
      await _drawBackEdges(canvas);
      _logger.info('Back-edge arrows drawn');

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
    final backEdgesSet = layout.backEdges.map((e) => '${e.from}->${e.to}').toSet();

    for (final edge in layout.edges) {
      // Create a unique key for this edge
      final edgeKey = '${edge.from}->${edge.to}';

      // Skip if we've already drawn this edge (handles cycles)
      if (drawnEdges.contains(edgeKey)) {
        _logger.fine('Skipping duplicate edge: $edgeKey');
        continue;
      }

      // Skip back edges - they will be drawn separately as curved arrows
      if (backEdgesSet.contains(edgeKey)) {
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

    _logger.info('Drew ${drawnEdges.length} unique forward edges (${layout.edges.length} total edges in graph)');
  }

  Future<void> _drawBackEdges(img.Image canvas) async {
    final backEdges = layout.backEdges;

    if (backEdges.isEmpty) {
      return;
    }

    // Calculate offsets for each back edge to avoid overlaps
    final offsets = _calculateBackEdgeOffsets(backEdges);

    // Track which target nodes already have back arrows (for optimization)
    final targetsWithBackArrows = <String>{};

    for (int i = 0; i < backEdges.length; i++) {
      final edge = backEdges[i];
      final fromNode = layout.nodesMap[edge.from];
      final toNode = layout.nodesMap[edge.to];

      if (fromNode == null || toNode == null) {
        _logger.warning('Back edge references missing node: ${edge.from} -> ${edge.to}');
        continue;
      }

      // Draw all back edges (even if target already has one)
      final offset = offsets[i];
      _drawBackEdgeArrow(canvas, fromNode, toNode, offset);
      targetsWithBackArrows.add(edge.to);
    }

    _logger.info('Drew ${backEdges.length} back-edge arrows');
  }

  /// Calculate vertical offsets for back edges to avoid overlaps
  List<int> _calculateBackEdgeOffsets(List<Edge> backEdges) {
    final baseOffset = 30;
    final offsetPerLevel = 40;
    final offsets = <int>[];

    for (int i = 0; i < backEdges.length; i++) {
      offsets.add(baseOffset + i * offsetPerLevel);
    }

    return offsets;
  }

  void _drawBackEdgeArrow(img.Image canvas, PositionedNode fromNode, PositionedNode toNode, int offset) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Calculate bottom Y position (including text) - use the maximum of both nodes
    final fromBottomY = fromNode.y + GraphLayout.nodeHeight + GraphLayout.textPadding + GraphLayout.textHeight;
    final toBottomY = toNode.y + GraphLayout.nodeHeight + GraphLayout.textPadding + GraphLayout.textHeight;
    final bottomY = fromBottomY > toBottomY ? fromBottomY : toBottomY;

    // Start point: bottom center of the "from" node (source, on the right)
    final startX = fromNode.x + GraphLayout.nodeWidth ~/ 2;
    final startY = bottomY;

    // End point: bottom center of the "to" node (target, on the left)
    final endX = toNode.x + GraphLayout.nodeWidth ~/ 2;
    final endY = bottomY;

    // The path: start -> down by offset -> horizontally left -> up by offset -> end
    final downY = startY + offset;
    final cornerRadius = 15.0;

    // Back edges always go from right to left (fromNode.level > toNode.level)
    // So we always go left, no need for the else clause

    final verticalDownEndY = downY - cornerRadius;

    // 3. Horizontal segment (going left)
    final horizontalStartX = startX - cornerRadius;
    final horizontalEndX = endX + cornerRadius;
    final verticalUpStartY = downY - cornerRadius;

    // 1. Vertical down from start
    _drawLine(canvas, startX, startY, startX, verticalDownEndY.round(), arrowThickness);

    // 2. Rounded corner: down to horizontal (turning left)
    _drawArcTopToLeft(canvas, startX.toDouble(), verticalDownEndY, horizontalStartX, horizontalEndX);

    // 3. Horizontal segment (going left)
    _drawLine(canvas, horizontalStartX.round(), downY, horizontalEndX.round(), downY, arrowThickness);

    // 4. Rounded corner: horizontal to up (turning left to up)
    _drawArcRightToTop(
        canvas, horizontalEndX.toDouble(), downY.toDouble(), endX.toDouble(), verticalUpStartY.toDouble());

    // 5. Vertical up to end
    _drawLine(canvas, endX, verticalUpStartY.round(), endX, endY, arrowThickness);

    // Draw arrowhead at the end (pointing to the target node)
    _drawArrowhead(canvas, endX, endY, endX, verticalUpStartY.round());
  }

  /// Draws a 90-degree quarter circle arc from 0° (pointing right) to 270° (pointing up)
  /// Calculates the center and radius from the start and end positions
  void _drawArcTopToLeft(
    img.Image canvas,
    double startX,
    double startY,
    double endX,
    double endY,
  ) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // For an arc from 0° to 270°:
    // - At 0° (pointing right): point is at (centerX + radius, centerY)
    // - At 270° (pointing up): point is at (centerX, centerY - radius)
    // So: centerX = endX, centerY = startY, radius = startX - endX = startY - endY

    final centerX = endX;
    final centerY = startY;
    final radius = (startX - endX).toDouble();

    // Verify the positions are consistent (radius should match vertical distance)
    final verticalRadius = (startY - endY).toDouble();
    if ((radius - verticalRadius).abs() > 1) {
      _logger.warning('Arc positions may be inconsistent: horizontal radius=$radius, vertical radius=$verticalRadius');
    }

    // Draw a 90-degree quarter circle arc from 0° to 270° (counter-clockwise)
    final startAngle = 0.0; // 0 degrees (pointing right)
    final numSegments = 90; // Segments for 90-degree arc

    // Go counter-clockwise from 0° to 270° (90 degrees total = π/2 radians)
    final angleStep = math.pi / 2 / numSegments; // Positive for clockwise

    for (int i = 0; i < numSegments; i++) {
      // Calculate angles along the arc (going clockwise)
      double angle1 = startAngle + i * angleStep;
      double angle2 = startAngle + (i + 1) * angleStep;

      // Calculate points on the arc
      final x1 = (centerX + radius * math.cos(angle1)).round();
      final y1 = (centerY + radius * math.sin(angle1)).round();
      final x2 = (centerX + radius * math.cos(angle2)).round();
      final y2 = (centerY + radius * math.sin(angle2)).round();

      img.drawLine(
        canvas,
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2,
        color: color,
        thickness: arrowThickness.toDouble(),
      );
    }
  }

  /// Draws a 90-degree quarter circle arc from 270° (pointing down/bottom) to 180° (pointing left)
  /// Calculates the center and radius from the start and end positions
  void _drawArcRightToTop(
    img.Image canvas,
    double startX,
    double startY,
    double endX,
    double endY,
  ) {
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // For an arc from 270° (bottom) to 180° (left):
    // - At 270° (pointing down): point is at (centerX, centerY + radius) in screen coords
    // - At 180° (pointing left): point is at (centerX - radius, centerY) in screen coords
    // So: centerX = startX, centerY = endY, radius = startX - endX = startY - endY

    final centerX = startX;
    final centerY = endY;
    final radius = (startX - endX).toDouble();

    // Verify the positions are consistent (radius should match vertical distance)
    final verticalRadius = (startY - endY).toDouble();
    if ((radius - verticalRadius).abs() > 1) {
      _logger.warning('Arc positions may be inconsistent: horizontal radius=$radius, vertical radius=$verticalRadius');
    }

    // Draw a 90-degree quarter circle arc from 270° to 180° (counter-clockwise)
    // In standard unit circle: 270° = 3π/2 (pointing down), 180° = π (pointing left)
    // Going counter-clockwise from 270° to 180° is 90 degrees
    final startAngle = 3 * math.pi / 2; // 270 degrees (pointing down/bottom)
    final numSegments = 90; // Segments for 90-degree arc

    // Go counter-clockwise from 270° to 180° (90 degrees total = π/2 radians)
    // Counter-clockwise means negative angle step: 270° → 180° = -90°
    final angleStep = -math.pi / 2 / numSegments; // Negative for counter-clockwise

    for (int i = 0; i < numSegments; i++) {
      // Calculate angles along the arc (going counter-clockwise)
      double angle1 = startAngle + i * angleStep;
      double angle2 = startAngle + (i + 1) * angleStep;

      // Calculate points on the arc
      // In screen coordinates (y increases downward), we need to negate the y component
      // from standard math coordinates to account for the flipped y-axis
      final x1 = (centerX + radius * math.cos(angle1)).round();
      final y1 = (centerY - radius * math.sin(angle1)).round(); // Negate for screen coords
      final x2 = (centerX + radius * math.cos(angle2)).round();
      final y2 = (centerY - radius * math.sin(angle2)).round(); // Negate for screen coords

      img.drawLine(
        canvas,
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2,
        color: color,
        thickness: arrowThickness.toDouble(),
      );
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
