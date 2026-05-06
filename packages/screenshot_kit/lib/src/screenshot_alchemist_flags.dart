import 'screenshot_define_keys.dart';

/// Compile-time helpers for wiring [Alchemist](https://pub.dev/packages/alchemist)
/// beside `screenshot_kit` (optional — this package does not depend on Alchemist).
abstract final class ScreenshotAlchemistFlags {
  ScreenshotAlchemistFlags._();

  /// Maps to [CiGoldensConfig.obscureText]: when `false`, CI golden PNGs keep normal
  /// glyphs (readable text).
  ///
  /// Default `true` matches Alchemist’s typical CI defaults.
  ///
  /// Toggle from the shell:
  /// `flutter test --dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false`.
  static bool get ciObscureText => bool.fromEnvironment(
        ScreenshotDefineKeys.alchemistObscureCiText,
        defaultValue: true,
      );
}
