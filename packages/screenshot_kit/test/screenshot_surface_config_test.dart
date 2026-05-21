import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  group('ScreenshotSurfaceConfig.fromDartDefines', () {
    test('parses light and dark', () {
      final light = ScreenshotSurfaceConfig.fromDartDefines(
        logicalWidth: 400,
        logicalHeight: 600,
        brightnessName: 'light',
      );
      expect(light.brightness, Brightness.light);
      expect(light.themeMode, ThemeMode.light);

      final dark = ScreenshotSurfaceConfig.fromDartDefines(
        logicalWidth: 400,
        logicalHeight: 600,
        brightnessName: 'dark',
      );
      expect(dark.brightness, Brightness.dark);
      expect(dark.themeMode, ThemeMode.dark);
    });

    test('defaults unknown brightness to light', () {
      final c = ScreenshotSurfaceConfig.fromDartDefines(
        logicalWidth: 1,
        logicalHeight: 1,
        brightnessName: 'unknown',
      );
      expect(c.brightness, Brightness.light);
    });
  });
}
