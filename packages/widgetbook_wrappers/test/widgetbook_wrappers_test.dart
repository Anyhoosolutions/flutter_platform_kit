import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_wrappers/widgetbook_wrappers.dart';

void main() {
  group('WidgetbookPhoneFrameConfig', () {
    test('commonPhones has devices and resolveInitialDeviceLabel', () {
      final config = WidgetbookPhoneFrameConfig.commonPhones();
      expect(config.devices, isNotEmpty);
      expect(config.resolveInitialDeviceLabel(), config.devices.first.label);
    });

    test('resolveInitialDeviceLabel falls back when label unknown', () {
      final config = WidgetbookPhoneFrameConfig(
        devices: [
          WidgetbookDeviceOption(device: Devices.ios.iPhoneSE, label: 'A'),
          WidgetbookDeviceOption(device: Devices.ios.iPhone13, label: 'B'),
        ],
        initialDeviceLabel: 'no-such-label',
      );
      expect(config.resolveInitialDeviceLabel(), 'A');
    });

    test('resolveInitialDeviceLabel honors initialDeviceLabel', () {
      final config = WidgetbookPhoneFrameConfig(
        devices: [
          WidgetbookDeviceOption(device: Devices.ios.iPhoneSE, label: 'A'),
          WidgetbookDeviceOption(device: Devices.ios.iPhone13, label: 'B'),
        ],
        initialDeviceLabel: 'B',
      );
      expect(config.resolveInitialDeviceLabel(), 'B');
    });
  });

  group('WidgetbookThemeConfig', () {
    test('defaults', () {
      final light = ThemeData.light();
      final dark = ThemeData.dark();
      final c = WidgetbookThemeConfig(light: light, dark: dark);
      expect(c.enableThemeKnob, isTrue);
      expect(c.initialThemeMode, ThemeMode.dark);
    });
  });
}
