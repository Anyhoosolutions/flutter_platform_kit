import 'package:flutter/material.dart';

import 'screenshot_define_keys.dart';

/// Parsed `--dart-define` values for screenshot / golden tests (viewport, theme, DPR).
///
/// Use [ScreenshotSurfaceConfig.fromEnvironment] in tests built with optional
/// `flutter test --dart-define=...` flags.
class ScreenshotSurfaceConfig {
  const ScreenshotSurfaceConfig({
    required this.logicalWidth,
    required this.logicalHeight,
    required this.brightness,
    required this.devicePixelRatio,
  }) : assert(logicalWidth > 0),
       assert(logicalHeight > 0),
       assert(devicePixelRatio > 0);

  factory ScreenshotSurfaceConfig.fromEnvironment() {
    return ScreenshotSurfaceConfig.fromDartDefines(
      logicalWidth: int.fromEnvironment(
        ScreenshotDefineKeys.logicalWidth,
        defaultValue: _defaultLogicalWidth,
      ),
      logicalHeight: int.fromEnvironment(
        ScreenshotDefineKeys.logicalHeight,
        defaultValue: _defaultLogicalHeight,
      ),
      brightnessName: const String.fromEnvironment(
        ScreenshotDefineKeys.brightness,
        defaultValue: 'light',
      ),
      devicePixelRatio: _devicePixelRatioFromEnvironment(),
    );
  }

  static double _devicePixelRatioFromEnvironment() {
    const raw = String.fromEnvironment(
      ScreenshotDefineKeys.devicePixelRatio,
      defaultValue: '',
    );
    if (raw.isEmpty) {
      return _defaultDevicePixelRatio;
    }
    return double.tryParse(raw) ?? _defaultDevicePixelRatio;
  }

  factory ScreenshotSurfaceConfig.fromDartDefines({
    required int logicalWidth,
    required int logicalHeight,
    required String brightnessName,
    double devicePixelRatio = _defaultDevicePixelRatio,
  }) {
    final brightness = _parseBrightness(brightnessName);
    return ScreenshotSurfaceConfig(
      logicalWidth: logicalWidth,
      logicalHeight: logicalHeight,
      brightness: brightness,
      devicePixelRatio: devicePixelRatio,
    );
  }

  static const int _defaultLogicalWidth = 390;
  static const int _defaultLogicalHeight = 844;
  static const double _defaultDevicePixelRatio = 1.0;

  final int logicalWidth;
  final int logicalHeight;
  final Brightness brightness;
  final double devicePixelRatio;

  ThemeMode get themeMode =>
      brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  Size get logicalSize =>
      Size(logicalWidth.toDouble(), logicalHeight.toDouble());

  static Brightness _parseBrightness(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'dark':
        return Brightness.dark;
      case 'light':
      default:
        return Brightness.light;
    }
  }
}
