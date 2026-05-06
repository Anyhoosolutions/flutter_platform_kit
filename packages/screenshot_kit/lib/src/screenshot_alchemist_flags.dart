import 'screenshot_define_keys.dart';

/// Compile-time helpers for wiring [Alchemist](https://pub.dev/packages/alchemist)
/// `CiGoldensConfig.obscureText` to [ScreenshotDefineKeys.alchemistObscureCiText].
///
/// This package does **not** add a dependency on Alchemist — add it in your app’s
/// `pubspec.yaml`.
abstract final class ScreenshotAlchemistFlags {
  ScreenshotAlchemistFlags._();

  /// **`true`** / **`false`** from [ScreenshotDefineKeys.alchemistObscureCiText].
  ///
  /// Omitted compile-time ⇒ **`true`** (obscured CI glyphs).
  static bool get ciObscureText => bool.fromEnvironment(
        ScreenshotDefineKeys.alchemistObscureCiText,
        defaultValue: true,
      );
}
