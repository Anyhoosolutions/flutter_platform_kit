import 'package:widgetbook_screenshots/src/collage_config.dart';

/// Represents a positioned screenshot in the collage
class PositionedCollageScreen {
  final CollageScreen screen;
  final int x;
  final int y;
  final int width;
  final int height;

  PositionedCollageScreen({
    required this.screen,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

/// Layout algorithm for collage positioning
class CollageLayout {
  final CollageConfig config;
  final Map<String, PositionedCollageScreen> screensMap = {};

  // Layout constants
  static const int baseScreenshotWidth = 350; // Base width from crop geometry
  static const int baseScreenshotHeight = 1080; // Base height from crop geometry
  static const int horizontalSpacing = 20; // Space between columns
  static const int verticalSpacing = 20; // Space between screens in same column
  static const int padding = 20; // Padding around entire collage
  static const int textPadding = 8; // Space between screenshot and text

  CollageLayout(this.config) {
    _buildLayout();
  }

  void _buildLayout() {
    // Group screens by column
    final screensByColumn = <int, List<CollageScreen>>{};
    for (final screen in config.screens) {
      screensByColumn.putIfAbsent(screen.column, () => []).add(screen);
    }

    // Sort screens within each column by columnPosition
    for (final column in screensByColumn.keys) {
      screensByColumn[column]!.sort((a, b) => a.columnPosition.compareTo(b.columnPosition));
    }

    // Calculate scaled dimensions
    final scaledWidth = (baseScreenshotWidth * config.scale).round();
    final scaledHeight = (baseScreenshotHeight * config.scale).round();

    // Calculate column widths (we'll need this for horizontal positioning)
    final maxColumn = screensByColumn.keys.isEmpty ? 0 : screensByColumn.keys.reduce((a, b) => a > b ? a : b);

    // Calculate positions for each column
    int currentX = padding;
    for (int column = 0; column <= maxColumn; column++) {
      final screensInColumn = screensByColumn[column] ?? [];
      if (screensInColumn.isEmpty) continue;

      // Start from top
      int currentY = padding;

      // Position each screen in this column
      for (final screen in screensInColumn) {
        screensMap[screen.name] = PositionedCollageScreen(
          screen: screen,
          x: currentX,
          y: currentY,
          width: scaledWidth,
          height: scaledHeight,
        );

        // Move down for next screen
        currentY += scaledHeight + verticalSpacing;
        if (config.useTitles) {
          // Estimate text height based on font size (rough approximation)
          final textHeight = (config.titleFontSize * 1.2).round();
          currentY += textPadding + textHeight;
        }
      }

      // Move to next column
      currentX += scaledWidth + horizontalSpacing;
    }
  }

  List<PositionedCollageScreen> get screens => screensMap.values.toList();

  /// Get the total dimensions needed for the canvas
  (int width, int height) getDimensions() {
    if (screensMap.isEmpty) {
      return (padding * 2, padding * 2);
    }

    int maxX = 0;
    int maxY = 0;

    for (final positionedScreen in screensMap.values) {
      final screenRight = positionedScreen.x + positionedScreen.width;
      final screenBottom = positionedScreen.y + positionedScreen.height;
      if (config.useTitles) {
        final textHeight = (config.titleFontSize * 1.2).round();
        final textBottom = screenBottom + textPadding + textHeight;
        if (textBottom > maxY) maxY = textBottom;
      } else {
        if (screenBottom > maxY) maxY = screenBottom;
      }
      if (screenRight > maxX) maxX = screenRight;
    }

    return (maxX + padding, maxY + padding);
  }
}
