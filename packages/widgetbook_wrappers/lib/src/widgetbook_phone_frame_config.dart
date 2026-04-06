import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';

import 'widgetbook_device_option.dart';

/// Knobs and frame chrome for phone-layout stories.
class WidgetbookPhoneFrameConfig {
  WidgetbookPhoneFrameConfig({
    required List<WidgetbookDeviceOption> devices,
    this.deviceKnobLabel = 'Device',
    this.orientationKnobLabel = 'Orientation',
    this.enableOrientationKnob = true,
    this.fixedOrientation = Orientation.portrait,
    this.showFrame = true,
    this.initialDeviceLabel,
  }) : devices = List<WidgetbookDeviceOption>.unmodifiable(devices),
       assert(devices.isNotEmpty, 'devices must not be empty');

  /// A few common phones (iOS + Android) for quick setup.
  factory WidgetbookPhoneFrameConfig.commonPhones() {
    final ios = Devices.ios;
    final android = Devices.android;
    return WidgetbookPhoneFrameConfig(
      devices: [
        WidgetbookDeviceOption(device: ios.iPhone13),
        WidgetbookDeviceOption(device: ios.iPhoneSE),
        WidgetbookDeviceOption(device: android.samsungGalaxyS20),
      ],
    );
  }

  factory WidgetbookPhoneFrameConfig.commonDevices() {
    final ios = Devices.ios;
    final android = Devices.android;
    final macOS = Devices.macOS;
    return WidgetbookPhoneFrameConfig(
      devices: [
        WidgetbookDeviceOption(device: ios.iPhone13),
        WidgetbookDeviceOption(device: ios.iPhoneSE),
        WidgetbookDeviceOption(device: android.samsungGalaxyS20),
        WidgetbookDeviceOption(device: ios.iPadAir4),
        WidgetbookDeviceOption(device: android.mediumTablet, label: 'Medium Android Tablet'),
        WidgetbookDeviceOption(device: android.largeTablet, label: 'Large Android Tablet'),
        WidgetbookDeviceOption(device: macOS.macBookPro),
        WidgetbookDeviceOption(device: macOS.wideMonitor, label: 'Wide Monitor'),
      ],
    );
  }

  final List<WidgetbookDeviceOption> devices;

  final String deviceKnobLabel;
  final String orientationKnobLabel;

  /// When false, [fixedOrientation] is used.
  final bool enableOrientationKnob;
  final Orientation fixedOrientation;

  /// Passed to [DeviceFrame.isFrameVisible].
  final bool showFrame;

  /// Initial entry in the device dropdown; must match a [WidgetbookDeviceOption.label].
  /// Defaults to the first device in [devices].
  final String? initialDeviceLabel;

  String get _defaultInitialLabel => devices.first.label;

  String resolveInitialDeviceLabel() {
    final wanted = initialDeviceLabel ?? _defaultInitialLabel;
    final labels = devices.map((e) => e.label).toSet();
    if (labels.contains(wanted)) return wanted;
    return _defaultInitialLabel;
  }
}
