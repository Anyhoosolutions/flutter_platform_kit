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

class Config {
  final String widgetbookUrl;
  final String outputDir;
  final List<Screen> screens;

  Config({
    required this.widgetbookUrl,
    required this.outputDir,
    required this.screens,
  });

  factory Config.fromJsonFile(String filePath) {
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
    );
  }

  String getFullUrl(Screen screen) {
    final baseUrl = widgetbookUrl.endsWith('/') ? widgetbookUrl.substring(0, widgetbookUrl.length - 1) : widgetbookUrl;
    final path = screen.path.startsWith('/') ? screen.path.substring(1) : screen.path;
    final fullUrl = '$baseUrl/#/?path=$path';
    print('Full URL: $fullUrl');
    return fullUrl;
  }
}


// http://localhost:45678/#/?path=pages/recipe/recipelistpage/recipelistpage
// http://localhost:45678/#/?path=pages/recipe/recipelistpage/recipelistpage

