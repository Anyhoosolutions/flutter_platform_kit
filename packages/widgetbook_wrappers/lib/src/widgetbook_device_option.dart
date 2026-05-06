import 'package:device_frame_plus/device_frame_plus.dart';

class WidgetbookDeviceOption {
  WidgetbookDeviceOption({
    required this.device,
    String? label,
  }) : label = label ?? device.name;

  final DeviceInfo device;
  final String label;
}
