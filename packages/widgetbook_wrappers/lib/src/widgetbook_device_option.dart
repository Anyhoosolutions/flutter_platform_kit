import 'package:device_frame_plus/device_frame_plus.dart';

/// A [DeviceInfo] preset for Widgetbook device knobs, with an optional label.
class WidgetbookDeviceOption {
  WidgetbookDeviceOption({required this.device, String? label})
    : label = label ?? device.name;

  final DeviceInfo device;

  /// Shown in the device dropdown (defaults to [DeviceInfo.name]).
  final String label;
}
