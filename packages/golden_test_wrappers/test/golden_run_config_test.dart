import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_test_wrappers/golden_test_wrappers.dart';

void main() {
  group('GoldenRunConfig.fromDartDefines', () {
    test('parses light and dark', () {
      final light = GoldenRunConfig.fromDartDefines(
        logicalWidth: 400,
        logicalHeight: 600,
        brightnessName: 'light',
      );
      expect(light.brightness, Brightness.light);
      expect(light.themeMode, ThemeMode.light);

      final dark = GoldenRunConfig.fromDartDefines(
        logicalWidth: 400,
        logicalHeight: 600,
        brightnessName: 'dark',
      );
      expect(dark.brightness, Brightness.dark);
      expect(dark.themeMode, ThemeMode.dark);
    });

    test('defaults unknown brightness to light', () {
      final c = GoldenRunConfig.fromDartDefines(
        logicalWidth: 1,
        logicalHeight: 1,
        brightnessName: 'unknown',
      );
      expect(c.brightness, Brightness.light);
    });
  });
}
