import 'dart:convert';
import 'dart:io';

class Screen {
  final String name;
  final String title;
  final String path;
  final List<String> navigatesTo;

  Screen({
    required this.name,
    required this.title,
    required this.path,
    required this.navigatesTo,
  });

  String get filename => '$name.png';

  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      name: json['name'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      navigatesTo: (json['navigatesTo'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class CropGeometry {
  final int width;
  final int height;
  final int xOffset;
  final int yOffset;

  CropGeometry({
    required this.width,
    required this.height,
    required this.xOffset,
    required this.yOffset,
  });

  factory CropGeometry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Default geometry for Playwright (similar to Python script)
      return CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0);
    }
    return CropGeometry(
      width: json['width'] as int? ?? 515,
      height: json['height'] as int? ?? 1080,
      xOffset: json['xOffset'] as int? ?? 700,
      yOffset: json['yOffset'] as int? ?? 0,
    );
  }
}

class Config {
  final String widgetbookUrl;
  final String outputDir;
  final List<Screen> screens;
  final CropGeometry cropGeometry;
  final bool darkMode;
  final String? deviceName;
  final String? orientation;
  final String? themeMode;
  final int cornerRadius;

  Config({
    required this.widgetbookUrl,
    required this.outputDir,
    required this.screens,
    required this.cropGeometry,
    this.darkMode = false,
    this.deviceName,
    this.orientation,
    this.themeMode,
    this.cornerRadius = 0,
  });

  factory Config.fromJsonFile(String filePath, {bool darkMode = false}) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('Config file not found: $filePath');
    }

    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;

    return Config(
      widgetbookUrl: json['widgetbookUrl'] as String? ?? 'http://localhost:45678',
      outputDir: json['outputDir'] as String? ?? './screenshots',
      screens: (json['screens'] as List<dynamic>).map((e) => Screen.fromJson(e as Map<String, dynamic>)).toList(),
      cropGeometry: CropGeometry.fromJson(json['cropGeometry'] as Map<String, dynamic>?),
      darkMode: darkMode,
      deviceName: json['deviceName'] as String?,
      orientation: json['orientation'] as String?,
      themeMode: json['themeMode'] as String?,
      cornerRadius: json['cornerRadius'] as int? ?? 0,
    );
  }

  String getFullUrl(Screen screen) {
    final baseUrl = widgetbookUrl.endsWith('/') ? widgetbookUrl.substring(0, widgetbookUrl.length - 1) : widgetbookUrl;
    final path = screen.path.startsWith('/') ? screen.path.substring(1) : screen.path;
    var url = '$baseUrl/#/?path=$path';

    final knobs = <String, String>{};
    if (deviceName != null && deviceName!.trim().isNotEmpty) {
      knobs['Device'] = deviceName!.trim();
    }
    if (orientation != null && orientation!.trim().isNotEmpty) {
      knobs['Orientation'] = orientation!.trim();
    }
    if (themeMode != null && themeMode!.trim().isNotEmpty) {
      knobs['Theme'] = themeMode!.trim();
    } else if (darkMode) {
      // Backwards compatibility for older dark-mode only callers.
      knobs['Theme'] = 'dark';
    }

    if (knobs.isNotEmpty) {
      final serializedKnobs = knobs.entries
          .map((entry) => '${Uri.encodeComponent(entry.key)}:${Uri.encodeComponent(entry.value)}')
          .join(',');
      url += '&knobs={$serializedKnobs}';
    }

    return url;
  }

  /// Get the filename for a screen, including dark mode suffix if applicable
  String getFilename(Screen screen) {
    if (darkMode) {
      return '${screen.name}-dark.png';
    }
    return screen.filename;
  }
}
