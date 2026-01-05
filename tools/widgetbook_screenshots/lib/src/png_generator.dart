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
    _logger.info('Drawing back-edge arrow from ${fromNode.screen.name} to ${toNode.screen.name} with offset $offset');
    final color = img.ColorRgb8(arrowColorR, arrowColorG, arrowColorB);

    // Calculate bottom Y position (including text) - use the maximum of both nodes
    final fromBottomY = fromNode.y + GraphLayout.nodeHeight + GraphLayout.textPadding + GraphLayout.textHeight;
    final toBottomY = toNode.y + GraphLayout.nodeHeight + GraphLayout.textPadding + GraphLayout.textHeight;
    final bottomY = fromBottomY > toBottomY ? fromBottomY : toBottomY;

    // Start point: bottom center of the "to" node (where the cycle returns to)
    final startX = toNode.x + GraphLayout.nodeWidth ~/ 2;
    final startY = bottomY;

    // End point: bottom center of the "from" node (where the cycle originates)
    final endX = fromNode.x + GraphLayout.nodeWidth ~/ 2;
    final endY = bottomY;

    // The path: start -> down by offset -> horizontally -> up by offset -> end
    final downY = startY + offset;
    final cornerRadius = 15.0;

    // Determine direction (left or right)
    final goingLeft = startX > endX;

    // Calculate path segments
    // 1. Vertical down from start (with rounded corner at bottom)
    final verticalDownEndY = downY - cornerRadius;
    _logger.info('Drawing vertical down line from ($startX, $startY) to ($startX, $verticalDownEndY)');
    _drawLine(canvas, startX, startY, startX, verticalDownEndY.round(), arrowThickness);

    // 2. Rounded corner: down to horizontal
    // Corner center is at the intersection point: (startX, downY)
    final corner1CenterX = startX;
    final corner1CenterY = downY;
    if (goingLeft) {
      // Turning left: arc from vertical line end to horizontal line start
      // Start: (startX, downY - radius) at angle 3π/2 from center (pointing "up" = smaller y)
      // End: (startX - radius, downY) at angle π from center (pointing left)
      _drawArcFromTo(
        canvas,
        corner1CenterX,
        corner1CenterY,
        cornerRadius,
        3 * math.pi / 2, // Start angle (where vertical line ends)
        math.pi, // End angle (left)
        color,
      );
    } else {
      // Turning right: arc from vertical line end to horizontal line start
      // Start: (startX, downY - radius) at angle 3π/2 from center
      // End: (startX + radius, downY) at angle 0 from center (pointing right)
      _drawArcFromTo(
        canvas,
        corner1CenterX,
        corner1CenterY,
        cornerRadius,
        3 * math.pi / 2, // Start angle (where vertical line ends)
        0, // End angle (right)
        color,
        clockwise: true,
      );
    }

    // 3. Horizontal segment
    final horizontalStartX = goingLeft ? startX - cornerRadius : startX + cornerRadius;
    final horizontalEndX = goingLeft ? endX + cornerRadius : endX - cornerRadius;
    _drawLine(canvas, horizontalStartX.round(), downY, horizontalEndX.round(), downY, arrowThickness);

    // 4. Rounded corner: horizontal to up
    // Corner center is at the intersection point: (endX, downY)
    final corner2CenterX = endX;
    final corner2CenterY = downY;
    if (goingLeft) {
      // Turning up from left: arc from left (π) to up (3π/2), counter-clockwise
      // Start: (endX - radius, downY) at angle π from center
      // End: (endX, downY - radius) at angle 3π/2 from center
      _drawArcFromTo(
        canvas,
        corner2CenterX,
        corner2CenterY,
        cornerRadius,
        math.pi, // Start angle (left)
        3 * math.pi / 2, // End angle (up)
        color,
      );
    } else {
      // Turning up from right: arc from right (0) to up (3π/2), clockwise
      // Start: (endX + radius, downY) at angle 0 from center
      // End: (endX, downY - radius) at angle 3π/2 from center
      _drawArcFromTo(
        canvas,
        corner2CenterX,
        corner2CenterY,
        cornerRadius,
        0, // Start angle (right)
        3 * math.pi / 2, // End angle (up)
        color,
        clockwise: true,
      );
    }

    // 5. Vertical up to end
    final verticalUpStartY = downY - cornerRadius;
    _drawLine(canvas, endX, verticalUpStartY.round(), endX, endY, arrowThickness);

    // Draw arrowhead at the end
    _drawArrowhead(canvas, endX, endY, startX, startY);
  }

  /// Draw an arc from startAngle to endAngle
  /// [clockwise] if true, draws the arc clockwise (shorter path), otherwise counter-clockwise
  void _drawArcFromTo(
    img.Image canvas,
    int centerX,
    int centerY,
    double radius,
    double startAngle,
    double endAngle,
    img.Color color, {
    bool clockwise = false,
  }) {
    final numSegments = 30; // More segments for smoother arcs

    // Normalize angles to [0, 2π)
    double normalizedStart = startAngle % (2 * math.pi);
    if (normalizedStart < 0) normalizedStart += 2 * math.pi;
    double normalizedEnd = endAngle % (2 * math.pi);
    if (normalizedEnd < 0) normalizedEnd += 2 * math.pi;

    // Calculate angle difference
    double angleDiff = normalizedEnd - normalizedStart;

    // Determine the correct direction
    if (clockwise) {
      // Clockwise: go the shorter negative way
      if (angleDiff > 0) {
        // If positive difference, go backwards (subtract 2π)
        angleDiff -= 2 * math.pi;
      }
      // If already negative, use as-is (it's already going clockwise)
    } else {
      // Counter-clockwise: go the shorter positive way
      if (angleDiff < 0) {
        // If negative difference, wrap around (add 2π)
        angleDiff += 2 * math.pi;
      }
      // If already positive, use as-is (it's already going counter-clockwise)
    }

    final angleStep = angleDiff / numSegments;

    for (int i = 0; i < numSegments; i++) {
      // Calculate angles along the arc
      double angle1 = normalizedStart + i * angleStep;
      double angle2 = normalizedStart + (i + 1) * angleStep;

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
