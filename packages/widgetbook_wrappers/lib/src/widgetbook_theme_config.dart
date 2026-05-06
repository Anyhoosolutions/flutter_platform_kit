import 'package:flutter/material.dart';

class WidgetbookThemeConfig {
  const WidgetbookThemeConfig({
    required this.light,
    required this.dark,
    this.enableThemeKnob = true,
    this.themeKnobLabel = 'Theme',
    this.initialThemeMode = ThemeMode.dark,
  });

  final ThemeData light;
  final ThemeData dark;
  final bool enableThemeKnob;
  final String themeKnobLabel;
  final ThemeMode initialThemeMode;
}
