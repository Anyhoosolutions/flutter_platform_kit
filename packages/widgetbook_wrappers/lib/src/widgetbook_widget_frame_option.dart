import 'package:flutter/material.dart';

import 'widgetbook_widget_frame_config.dart';

class WidgetFrameSizeOption {
  const WidgetFrameSizeOption({
    required this.name,
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white,
  });

  final String name;
  final double width;
  final double height;
  final Color backgroundColor;
}

WidgetFrameSizeOption fromWidgetFrameSize(WidgetFrameSize widgetFrameSize) {
  return switch (widgetFrameSize) {
    WidgetFrameSize.small =>
      const WidgetFrameSizeOption(name: 'Small', width: 200, height: 100),
    WidgetFrameSize.medium =>
      const WidgetFrameSizeOption(name: 'Medium', width: 300, height: 200),
    WidgetFrameSize.large =>
      const WidgetFrameSizeOption(name: 'Large', width: 500, height: 300),
    WidgetFrameSize.custom =>
      const WidgetFrameSizeOption(name: 'Custom', width: 800, height: 500),
  };
}
