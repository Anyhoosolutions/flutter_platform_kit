enum WidgetFrameSize { small, medium, large, custom }

class WidgetbookWidgetFrameConfig {
  WidgetbookWidgetFrameConfig({
    required List<WidgetFrameSize> widgetFrames,
    this.widgetFrameKnobLabel = 'Frame size',
    this.initialWidgetFrameLabel,
  }) : widgetFrames = List<WidgetFrameSize>.unmodifiable(widgetFrames),
       assert(widgetFrames.isNotEmpty, 'widgetFrames must not be empty');

  factory WidgetbookWidgetFrameConfig.allFrames() {
    return WidgetbookWidgetFrameConfig(widgetFrames: WidgetFrameSize.values);
  }

  final List<WidgetFrameSize> widgetFrames;
  final String widgetFrameKnobLabel;
  final WidgetFrameSize? initialWidgetFrameLabel;

  WidgetFrameSize get _defaultInitialSize {
    if (widgetFrames.contains(WidgetFrameSize.large)) {
      return WidgetFrameSize.large;
    }
    return widgetFrames.first;
  }

  WidgetFrameSize resolveInitialWidgetFrame() {
    final wanted = initialWidgetFrameLabel ?? _defaultInitialSize;
    if (widgetFrames.contains(wanted)) {
      return wanted;
    }
    return _defaultInitialSize;
  }
}
