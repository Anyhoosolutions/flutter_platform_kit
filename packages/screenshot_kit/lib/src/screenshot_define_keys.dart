/// Compile-time keys for `--dart-define` — keep aligned with [buildFlutterTestArgs].
abstract final class ScreenshotDefineKeys {
  ScreenshotDefineKeys._();

  static const String logicalWidth = 'SCREENSHOT_LOGICAL_WIDTH';
  static const String logicalHeight = 'SCREENSHOT_LOGICAL_HEIGHT';
  static const String brightness = 'SCREENSHOT_BRIGHTNESS';
  static const String devicePixelRatio = 'SCREENSHOT_DEVICE_PIXEL_RATIO';
}
