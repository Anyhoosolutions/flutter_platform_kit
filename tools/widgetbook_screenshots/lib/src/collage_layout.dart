import 'package:widgetbook_screenshots/src/collage_config.dart';

/// Represents a positioned screenshot in the collage
class PositionedCollageScreen {
  final CollageScreen screen;
  final int x;
  final int y;
  final int width;
  final int height;
  final int titleX; // Center X for title
  final int titleY; // Baseline Y for title

  PositionedCollageScreen({
    required this.screen,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.titleX,
    required this.titleY,
  });
}

/// Layout algorithm for collage positioning
class CollageLayout {
  final CollageConfig config;
  final Map<String, PositionedCollageScreen> screensMap = {};

  // Layout constants
  static const int baseScreenshotWidth = 350; // Base width from crop geometry
  static const int baseScreenshotHeight = 1080; // Base height from crop geometry
  static const int defaultHorizontalPadding = 20; // Default horizontal padding on left/right
  static const int defaultColumnSpacing = 20; // Default space between columns
  static const int defaultVerticalSpacing = 20; // Default space between screens in same column
  static const int defaultTitlePadding = 8; // Default space between screenshot and text

  // Calculated dimensions (set during layout building)
  late final int screenshotWidth;
  late final int screenshotHeight;
  late final int titleSpacingHeight; // Height to add after title baseline for spacing (descender height)
  late final int actualTitleHeight; // Actual font size/line height

  /// Creates a CollageLayout with optional actual screenshot dimensions.
  /// If [actualScreenshotWidth] and [actualScreenshotHeight] are provided,
  /// they will be used instead of the configured cropGeometry dimensions.
  /// This allows the layout to match the actual image sizes.
  CollageLayout(this.config, {int? actualScreenshotWidth, int? actualScreenshotHeight}) {
    _buildLayout(actualScreenshotWidth: actualScreenshotWidth, actualScreenshotHeight: actualScreenshotHeight);
  }

  /// Get the scaled screenshot dimensions (all screenshots are the same size)
  ({int width, int height}) getScreenshotDimensions() {
    return (width: screenshotWidth, height: screenshotHeight);
  }

  /// Get the height of the title text (0 if titles are not used)
  /// Returns the actual font size/line height
  int getTitleHeight() {
    return actualTitleHeight;
  }

  /// Get the position map for debugging/inspection
  Map<String, PositionedCollageScreen> getPositionMap() {
    return Map.from(screensMap);
  }

  void _buildLayout({int? actualScreenshotWidth, int? actualScreenshotHeight}) {
    // Step 1: Calculate screenshot dimensions after scaling (all screenshots are the same size)
    // Use actual dimensions if provided, otherwise use configured dimensions
    if (actualScreenshotWidth != null && actualScreenshotHeight != null) {
      screenshotWidth = (actualScreenshotWidth * config.scale).round();
      screenshotHeight = (actualScreenshotHeight * config.scale).round();
    } else {
      screenshotWidth = (baseScreenshotWidth * config.scale).round();
      screenshotHeight = (baseScreenshotHeight * config.scale).round();
    }

    // Step 2: Calculate title heights (0 if titles are not used)
    if (config.useTitles) {
      actualTitleHeight = config.titleFontSize; // Actual font size
      titleSpacingHeight = _getFontSpacingHeight(config.titleFontSize); // Minimal descender height for spacing
    } else {
      actualTitleHeight = 0;
      titleSpacingHeight = 0;
    }

    // Step 3: Group screens by column
    final screensByColumn = <int, List<CollageScreen>>{};
    for (final screen in config.screens) {
      screensByColumn.putIfAbsent(screen.column, () => []).add(screen);
    }

    // Sort screens within each column by columnPosition
    for (final column in screensByColumn.keys) {
      screensByColumn[column]!.sort((a, b) => a.columnPosition.compareTo(b.columnPosition));
    }

    // Calculate column widths (we'll need this for horizontal positioning)
    final maxColumn = screensByColumn.keys.isEmpty ? 0 : screensByColumn.keys.reduce((a, b) => a > b ? a : b);

    // Calculate positions for each column
    final horizontalPadding = config.horizontalPadding ?? defaultHorizontalPadding;
    final columnSpacing = config.columnSpacing ?? defaultColumnSpacing;
    int currentX = horizontalPadding;
    for (int column = 0; column <= maxColumn; column++) {
      final screensInColumn = screensByColumn[column] ?? [];
      if (screensInColumn.isEmpty) continue;

      // Start from top - use column-specific top if configured (0 means very top of image),
      // otherwise use 0. Note: 0 is a valid value, so we check for null, not falsy.
      int currentY = config.columnTops.containsKey(column) ? config.columnTops[column]! : 0;

      // Step 4: Position each screen in this column and build the position map
      for (final screen in screensInColumn) {
        final titlePadding = config.useTitles ? (config.titlePadding ?? defaultTitlePadding) : 0;
        // When titlePadding = 0, we need to account for font height to prevent text overlap
        // drawString uses baseline Y, which is near the bottom of text. To position text
        // below the screenshot when padding is 0, we add the font height to the baseline Y.
        final titleBaselineY = currentY +
            screenshotHeight +
            titlePadding +
            (titlePadding == 0 && config.useTitles ? actualTitleHeight : 0);
        screensMap[screen.name] = PositionedCollageScreen(
          screen: screen,
          x: currentX,
          y: currentY,
          width: screenshotWidth,
          height: screenshotHeight,
          titleX: currentX + screenshotWidth ~/ 2,
          titleY: titleBaselineY,
        );

        // Move down for next screen
        currentY += screenshotHeight;

        // Add title space if titles are enabled
        if (config.useTitles) {
          final titlePadding = config.titlePadding ?? defaultTitlePadding;
          // When titlePadding = 0, titleY already includes fontHeight to position text below screenshot.
          // The text extends from approximately (titleY - fontHeight) to (titleY + titleSpacingHeight),
          // so we need to account for the full text height: fontHeight + titleSpacingHeight.
          // When titlePadding > 0, add padding + spacing.
          currentY += titlePadding == 0 ? actualTitleHeight + titleSpacingHeight : titlePadding + titleSpacingHeight;
        }

        // Add spacing before next screen (after title or after screen if no title)
        final screenSpacing = config.screenSpacing ?? defaultVerticalSpacing;
        currentY += screenSpacing;
      }

      // Move to next column
      currentX += screenshotWidth + columnSpacing;
    }
  }

  List<PositionedCollageScreen> get screens => screensMap.values.toList();

  /// Get the total dimensions needed for the canvas
  ({int width, int height}) getDimensions() {
    final horizontalPadding = config.horizontalPadding ?? defaultHorizontalPadding;
    if (screensMap.isEmpty) {
      return (width: horizontalPadding * 2, height: 0);
    }

    int maxX = 0;
    int maxY = 0;

    for (final positionedScreen in screensMap.values) {
      final screenRight = positionedScreen.x + positionedScreen.width;
      final screenBottom = positionedScreen.y + positionedScreen.height;
      if (config.useTitles) {
        final titlePadding = config.titlePadding ?? defaultTitlePadding;
        final textBottom = screenBottom + titlePadding + actualTitleHeight;
        if (textBottom > maxY) maxY = textBottom;
      } else {
        if (screenBottom > maxY) maxY = screenBottom;
      }
      if (screenRight > maxX) maxX = screenRight;
    }

    return (width: maxX + horizontalPadding, height: maxY);
  }

  /// Get the height to add after the text baseline for spacing calculations
  /// Note: drawString uses baseline Y coordinate. For bitmap fonts, the baseline
  /// is typically at the bottom of most characters. Most text sits on the baseline,
  /// with only descenders (g, p, y, etc.) extending below. Since we want tight spacing
  /// when screenSpacing is 0, we use a minimal value - just 1px to account for any
  /// potential descenders or rendering artifacts.
  int _getFontSpacingHeight(int fontSize) {
    // Use minimal value (1px) - the baseline is already at the bottom of most text
    // This ensures the next screen is positioned right below the visible text
    // when screenSpacing is 0
    return 1;
  }
}
