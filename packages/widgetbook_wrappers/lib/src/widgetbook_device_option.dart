import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'widgetbook_device_option.freezed.dart';

/// A [DeviceInfo] preset for Widgetbook device knobs, with an optional label.
@freezed
abstract class WidgetbookDeviceOption with _$WidgetbookDeviceOption {
  const WidgetbookDeviceOption._();

  /// Full constructor when both [device] and [label] are already resolved.
  const factory WidgetbookDeviceOption.raw({
    required DeviceInfo device,
    required String label,
  }) = _WidgetbookDeviceOption;

  /// [label] is shown in the device dropdown (defaults to [DeviceInfo.name]).
  factory WidgetbookDeviceOption({
    required DeviceInfo device,
    String? label,
  }) =>
      WidgetbookDeviceOption.raw(
        device: device,
        label: label ?? device.name,
      );
}
