import 'dart:convert';
import 'dart:io';
import 'package:widgetbook_screenshots/src/config.dart';

class CollageScreen {
  final String name;
  final String title;
  final String path;
  final int column;
  final int columnPosition;

  CollageScreen({
    required this.name,
    required this.title,
    required this.path,
    required this.column,
    required this.columnPosition,
  });

  String get filename => '$name.png';

  factory CollageScreen.fromJson(Map<String, dynamic> json) {
    return CollageScreen(
      name: json['name'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      column: json['column'] as int,
      columnPosition: json['columnPosition'] as int,
    );
  }
}

class CollageConfig {
  final String widgetbookUrl;
  final String outputDir;
  final List<CollageScreen> screens;
  final CropGeometry cropGeometry;
  final bool darkMode;
  final double scale;
  final String backgroundColor;
  final bool useTitles;
  final int titleFontSize;
  final int cornerRadius;
  final Map<int, int> columnTops; // Maps column number to top position
  final int? titleOffset; // Pixels below screenshot edge to place title top (null = use default)
  final int? screenSpacing; // Spacing between screens in same column (null = use default)
  final int? horizontalPadding; // Horizontal padding on left/right (null = use default)
  final int? columnSpacing; // Spacing between columns (null = use default)

  CollageConfig({
    required this.widgetbookUrl,
    required this.outputDir,
    required this.screens,
    required this.cropGeometry,
    this.darkMode = false,
    this.scale = 1.0,
    this.backgroundColor = '#F8F9FA',
    this.useTitles = false,
    this.titleFontSize = 24,
    this.cornerRadius = 0,
    Map<int, int>? columnTops,
    this.titleOffset,
    this.screenSpacing,
    this.horizontalPadding,
    this.columnSpacing,
  }) : columnTops = columnTops ?? {};

  factory CollageConfig.fromJsonFile(String filePath, {bool darkMode = false}) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('Config file not found: $filePath');
    }

    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;

    // Parse column tops configuration
    Map<int, int> columnTops = {};
    if (json['columns'] != null) {
      final columnsJson = json['columns'] as Map<String, dynamic>;
      columnsJson.forEach((key, value) {
        final column = int.parse(key);
        final top = value is Map<String, dynamic> && value['top'] != null ? (value['top'] as num).toInt() : null;
        if (top != null) {
          columnTops[column] = top;
        }
      });
    }

    return CollageConfig(
      widgetbookUrl: json['widgetbookUrl'] as String? ?? 'http://localhost:45678',
      outputDir: json['outputDir'] as String? ?? './screenshots',
      screens:
          (json['screens'] as List<dynamic>).map((e) => CollageScreen.fromJson(e as Map<String, dynamic>)).toList(),
      cropGeometry: CropGeometry.fromJson(json['cropGeometry'] as Map<String, dynamic>?),
      darkMode: darkMode,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
      backgroundColor: json['backgroundColor'] as String? ?? '#F8F9FA',
      useTitles: json['useTitles'] as bool? ?? false,
      titleFontSize: json['titleFontSize'] as int? ?? 24,
      cornerRadius: json['cornerRadius'] as int? ?? 0,
      columnTops: columnTops,
      titleOffset: json['titleOffset'] != null ? (json['titleOffset'] as num).toInt() : null,
      screenSpacing: json['screenSpacing'] != null ? (json['screenSpacing'] as num).toInt() : null,
      horizontalPadding: json['horizontalPadding'] != null ? (json['horizontalPadding'] as num).toInt() : null,
      columnSpacing: json['columnSpacing'] != null ? (json['columnSpacing'] as num).toInt() : null,
    );
  }

  String getFullUrl(CollageScreen screen) {
    final baseUrl = widgetbookUrl.endsWith('/') ? widgetbookUrl.substring(0, widgetbookUrl.length - 1) : widgetbookUrl;
    final path = screen.path.startsWith('/') ? screen.path.substring(1) : screen.path;
    var url = '$baseUrl/#/?path=$path';

    // Append dark mode knobs if dark mode is enabled
    if (darkMode) {
      url += '&knobs={Theme%20mode:dark}';
    }

    return url;
  }

  /// Get the filename for a screen, including dark mode suffix if applicable
  String getFilename(CollageScreen screen) {
    if (darkMode) {
      return '${screen.name}-dark.png';
    }
    return screen.filename;
  }

  /// Parse hex color string (e.g., "#F8F9FA" or "F8F9FA") to RGB values
  ({int r, int g, int b}) getBackgroundColorRgb() {
    String hex = backgroundColor;
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.length == 6) {
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      return (r: r, g: g, b: b);
    }
    // Default to light gray if parsing fails
    return (r: 248, g: 249, b: 250);
  }
}
