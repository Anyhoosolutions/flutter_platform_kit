import 'package:flutter/material.dart';

/// Theme data and optional theme knob for [WidgetbookStoryShell].
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

  /// When false, [initialThemeMode] is always used (no knob).
  final bool enableThemeKnob;
  final String themeKnobLabel;
  final ThemeMode initialThemeMode;
}
