import 'package:flutter/material.dart';

import 'golden_define_keys.dart';

/// Parsed `--dart-define` values for golden runs (viewport, theme, DPR).
///
/// Use [GoldenRunConfig.fromEnvironment] in tests compiled with optional
/// defines from `golden_screenshots` or CI.
class GoldenRunConfig {
  const GoldenRunConfig({
    required this.logicalWidth,
    required this.logicalHeight,
    required this.brightness,
    required this.devicePixelRatio,
  }) : assert(logicalWidth > 0),
       assert(logicalHeight > 0),
       assert(devicePixelRatio > 0);

  /// Reads compile-time defines ([GoldenDefineKeys]).
  factory GoldenRunConfig.fromEnvironment() {
    return GoldenRunConfig.fromDartDefines(
      logicalWidth: int.fromEnvironment(
        GoldenDefineKeys.logicalWidth,
        defaultValue: _defaultLogicalWidth,
      ),
      logicalHeight: int.fromEnvironment(
        GoldenDefineKeys.logicalHeight,
        defaultValue: _defaultLogicalHeight,
      ),
      brightnessName: const String.fromEnvironment(
        GoldenDefineKeys.brightness,
        defaultValue: 'light',
      ),
      devicePixelRatio: _devicePixelRatioFromEnvironment(),
    );
  }

  static double _devicePixelRatioFromEnvironment() {
    const raw = String.fromEnvironment(
      GoldenDefineKeys.devicePixelRatio,
      defaultValue: '',
    );
    if (raw.isEmpty) {
      return _defaultDevicePixelRatio;
    }
    return double.tryParse(raw) ?? _defaultDevicePixelRatio;
  }

  /// Same parsing as [fromEnvironment], but usable from unit tests.
  factory GoldenRunConfig.fromDartDefines({
    required int logicalWidth,
    required int logicalHeight,
    required String brightnessName,
    double devicePixelRatio = _defaultDevicePixelRatio,
  }) {
    final brightness = _parseBrightness(brightnessName);
    return GoldenRunConfig(
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
