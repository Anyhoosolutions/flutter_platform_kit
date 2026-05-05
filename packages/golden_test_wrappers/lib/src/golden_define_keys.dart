/// Compile-time keys read via `fromEnvironment` — keep in sync with
/// `tools/golden_screenshots` CLI defaults.
abstract final class GoldenDefineKeys {
  GoldenDefineKeys._();

  /// Logical width in pixels (`flutter test` surface).
  static const String logicalWidth = 'GOLDEN_LOGICAL_WIDTH';

  /// Logical height in pixels (`flutter test` surface).
  static const String logicalHeight = 'GOLDEN_LOGICAL_HEIGHT';

  /// `light` or `dark`.
  static const String brightness = 'GOLDEN_BRIGHTNESS';

  /// Device pixel ratio for [GoldenRunConfig.devicePixelRatio].
  static const String devicePixelRatio = 'GOLDEN_DEVICE_PIXEL_RATIO';
}
