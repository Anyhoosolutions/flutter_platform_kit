import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';

import 'widgetbook_device_option.dart';

class WidgetbookPhoneFrameConfig {
  static const Object _copyWithUnset = Object();

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

  factory WidgetbookPhoneFrameConfig.commonDevices({
    List<DeviceType>? deviceTypes,
  }) {
    final ios = Devices.ios;
    final android = Devices.android;
    final macOS = Devices.macOS;
    return WidgetbookPhoneFrameConfig(
      devices: [
        if (deviceTypes?.contains(DeviceType.phone) ?? true) ...[
          WidgetbookDeviceOption(device: ios.iPhone13, label: 'iPhone_13'),
          WidgetbookDeviceOption(device: ios.iPhoneSE, label: 'iPhone_SE'),
          WidgetbookDeviceOption(
            device: android.samsungGalaxyS20,
            label: 'Samsung_Galaxy_S20',
          ),
        ],
        if (deviceTypes?.contains(DeviceType.tablet) ?? true) ...[
          WidgetbookDeviceOption(device: ios.iPadAir4, label: 'iPad_Air_4'),
          WidgetbookDeviceOption(
            device: android.mediumTablet,
            label: 'Medium_Android_Tablet',
          ),
          WidgetbookDeviceOption(
            device: android.largeTablet,
            label: 'Large_Android_Tablet',
          ),
        ],
        if (deviceTypes?.contains(DeviceType.desktop) ?? true) ...[
          WidgetbookDeviceOption(device: macOS.macBookPro, label: 'MacBook_Pro'),
          WidgetbookDeviceOption(
            device: macOS.wideMonitor,
            label: 'Wide_Monitor',
          ),
        ],
      ],
    );
  }

  final List<WidgetbookDeviceOption> devices;
  final String deviceKnobLabel;
  final String orientationKnobLabel;
  final bool enableOrientationKnob;
  final Orientation fixedOrientation;
  final bool showFrame;
  final String? initialDeviceLabel;

  WidgetbookPhoneFrameConfig copyWith({
    Object? devices = _copyWithUnset,
    Object? deviceKnobLabel = _copyWithUnset,
    Object? orientationKnobLabel = _copyWithUnset,
    Object? enableOrientationKnob = _copyWithUnset,
    Object? fixedOrientation = _copyWithUnset,
    Object? showFrame = _copyWithUnset,
    Object? initialDeviceLabel = _copyWithUnset,
  }) {
    return WidgetbookPhoneFrameConfig(
      devices: devices == _copyWithUnset
          ? this.devices
          : devices as List<WidgetbookDeviceOption>,
      deviceKnobLabel: deviceKnobLabel == _copyWithUnset
          ? this.deviceKnobLabel
          : deviceKnobLabel as String,
      orientationKnobLabel: orientationKnobLabel == _copyWithUnset
          ? this.orientationKnobLabel
          : orientationKnobLabel as String,
      enableOrientationKnob: enableOrientationKnob == _copyWithUnset
          ? this.enableOrientationKnob
          : enableOrientationKnob as bool,
      fixedOrientation: fixedOrientation == _copyWithUnset
          ? this.fixedOrientation
          : fixedOrientation as Orientation,
      showFrame: showFrame == _copyWithUnset
          ? this.showFrame
          : showFrame as bool,
      initialDeviceLabel: initialDeviceLabel == _copyWithUnset
          ? this.initialDeviceLabel
          : initialDeviceLabel as String?,
    );
  }

  String get _defaultInitialLabel => devices.first.label;

  String resolveInitialDeviceLabel() {
    final wanted = initialDeviceLabel ?? _defaultInitialLabel;
    final labels = devices.map((e) => e.label).toSet();
    if (labels.contains(wanted)) {
      return wanted;
    }
    return _defaultInitialLabel;
  }
}
