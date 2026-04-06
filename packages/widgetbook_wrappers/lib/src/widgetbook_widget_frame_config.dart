import 'package:flutter/material.dart';
import 'package:widgetbook_wrappers/src/widgetbook_widget_frame_option.dart';

final customWidgetFrameLabel = 'Custom';
final allWidgetFrames = [
  WidgetFrameSize(name: 'Small', width: 200, height: 100),
  WidgetFrameSize(name: 'Medium', width: 300, height: 200),
  WidgetFrameSize(name: 'Large', width: 500, height: 300),
  WidgetFrameSize(name: customWidgetFrameLabel, width: 800, height: 500),
  WidgetFrameSize(name: 'Large - Blue', width: 600, height: 600, backgroundColor: Colors.blue),
];

/// Knobs and frame chrome for phone-layout stories.
class WidgetbookWidgetFrameConfig {
  WidgetbookWidgetFrameConfig({
    required List<WidgetFrameSize> widgetFrames,
    this.widgetFrameKnobLabel = 'Frame size',
    this.showFrame = true,
    this.initialWidgetFrameLabel,
  }) : widgetFrames = List<WidgetFrameSize>.unmodifiable(widgetFrames),
       assert(widgetFrames.isNotEmpty, 'devices must not be empty');

  /// A few common phones (iOS + Android) for quick setup.
  factory WidgetbookWidgetFrameConfig.allFrames() {
    return WidgetbookWidgetFrameConfig(widgetFrames: allWidgetFrames);
  }

  final List<WidgetFrameSize> widgetFrames;
  final String widgetFrameKnobLabel;
  final bool showFrame;
  final String? initialWidgetFrameLabel;

  String get _defaultInitialLabel => widgetFrames.first.name;

  String resolveInitialDeviceLabel() {
    final wanted = initialWidgetFrameLabel ?? _defaultInitialLabel;
    final labels = widgetFrames.map((e) => e.name).toSet();
    if (labels.contains(wanted)) return wanted;
    return _defaultInitialLabel;
  }
}
