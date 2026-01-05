import 'package:test/test.dart';
import 'package:widgetbook_screenshots/src/collage_config.dart';
import 'package:widgetbook_screenshots/src/collage_layout.dart';
import 'package:widgetbook_screenshots/src/config.dart';

void main() {
  group('CollageLayout Position Map', () {
    test('calculates screenshot dimensions correctly', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        scale: 1.0,
      );

      final layout = CollageLayout(config);
      final dimensions = layout.getScreenshotDimensions();

      expect(dimensions.width, 350); // baseScreenshotWidth * scale
      expect(dimensions.height, 1080); // baseScreenshotHeight * scale
    });

    test('calculates screenshot dimensions with scaling', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        scale: 0.5,
      );

      final layout = CollageLayout(config);
      final dimensions = layout.getScreenshotDimensions();

      expect(dimensions.width, 175); // 350 * 0.5
      expect(dimensions.height, 540); // 1080 * 0.5
    });

    test('calculates title height as 0 when titles disabled', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
      );

      final layout = CollageLayout(config);
      expect(layout.getTitleHeight(), 0);
    });

    test('calculates title height when titles enabled', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: true,
        titleFontSize: 24,
      );

      final layout = CollageLayout(config);
      // Title height should match the font size
      expect(layout.getTitleHeight(), 24);
    });

    test('generates position map for single screen', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      expect(positionMap.length, 1);
      expect(positionMap.containsKey('screen1'), isTrue);

      final screen1 = positionMap['screen1']!;
      expect(screen1.screen.name, 'screen1');
      expect(screen1.screen.title, 'Screen 1');
      expect(screen1.x, 20); // padding
      expect(screen1.y, 0); // no vertical padding
      expect(screen1.width, 350);
      expect(screen1.height, 1080);
      expect(screen1.titleX, 195); // x + width / 2 = 20 + 350 / 2
      expect(screen1.titleY, 1080); // y + height + titlePadding = 0 + 1080 + 0
    });

    test('generates position map with custom title padding', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: true,
        titlePadding: 10,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.titleY, 1110); // y + height + titlePadding = 20 + 1080 + 10
    });

    test('generates position map for multiple screens in one column', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 0,
            columnPosition: 1,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        screenSpacing: 0,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      expect(positionMap.length, 2);

      final screen1 = positionMap['screen1']!;
      expect(screen1.x, 20);
      expect(screen1.y, 0);

      final screen2 = positionMap['screen2']!;
      expect(screen2.x, 20); // Same column
      expect(screen2.y, 1080); // screen1.y + screen1.height + screenSpacing = 0 + 1080 + 0
    });

    test('generates position map with screen spacing', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 0,
            columnPosition: 1,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        screenSpacing: 30,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen2 = positionMap['screen2']!;
      expect(screen2.y, 1110); // screen1.y + screen1.height + screenSpacing = 0 + 1080 + 30
    });

    test('generates position map with titles and spacing', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 0,
            columnPosition: 1,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: true,
        titlePadding: 10,
        screenSpacing: 5,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.y, 0);

      // screen2.y = screen1.y + screen1.height + titlePadding + titleSpacingHeight + screenSpacing
      // = 0 + 1080 + 10 + 1 + 5 = 1096
      final screen2 = positionMap['screen2']!;
      expect(screen2.y, 1096);
    });

    test('generates position map for multiple columns', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 1,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.x, 20); // padding
      expect(screen1.y, 0); // no vertical padding

      final screen2 = positionMap['screen2']!;
      expect(screen2.x, 390); // screen1.x + screen1.width + horizontalSpacing = 20 + 350 + 20
      expect(screen2.y, 0); // no vertical padding (same row)
    });

    test('generates position map with column top positions', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 1,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        columnTops: {0: 0, 1: 100},
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.y, 0); // column top = 0

      final screen2 = positionMap['screen2']!;
      expect(screen2.y, 100); // column top = 100
    });

    test('generates position map with column top at 0 (very top)', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        columnTops: {0: 0},
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.y, 0); // Should be at very top, not padding
    });

    test('generates position map with negative column top', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        columnTops: {0: -50},
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.y, -50); // Negative top position allowed
    });

    test('generates correct title positions in position map', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: true,
        titlePadding: 15,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.titleX, 195); // x + width / 2 = 20 + 350 / 2
      expect(screen1.titleY, 1095); // y + height + titlePadding = 0 + 1080 + 15
    });

    test('sorts screens by columnPosition within column', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 0,
            columnPosition: 2,
          ),
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen3',
            title: 'Screen 3',
            path: '/screen3',
            column: 0,
            columnPosition: 1,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        useTitles: false,
        screenSpacing: 0,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      final screen2 = positionMap['screen2']!;
      final screen3 = positionMap['screen3']!;

      expect(screen1.y, 0); // First position
      expect(screen3.y, 1080); // Second position (columnPosition 1)
      expect(screen2.y, 2160); // Third position (columnPosition 2)
    });

    test('generates position map with custom horizontal padding', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        horizontalPadding: 50,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      expect(screen1.x, 50); // custom horizontal padding
    });

    test('generates position map with custom column spacing', () {
      final config = CollageConfig(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          CollageScreen(
            name: 'screen1',
            title: 'Screen 1',
            path: '/screen1',
            column: 0,
            columnPosition: 0,
          ),
          CollageScreen(
            name: 'screen2',
            title: 'Screen 2',
            path: '/screen2',
            column: 1,
            columnPosition: 0,
          ),
        ],
        cropGeometry: CropGeometry(width: 350, height: 1080, xOffset: 465, yOffset: 0),
        columnSpacing: 50,
      );

      final layout = CollageLayout(config);
      final positionMap = layout.getPositionMap();

      final screen1 = positionMap['screen1']!;
      final screen2 = positionMap['screen2']!;
      expect(screen1.x, 20); // default horizontal padding
      expect(screen2.x, 420); // screen1.x + screen1.width + columnSpacing = 20 + 350 + 50
    });
  });
}
