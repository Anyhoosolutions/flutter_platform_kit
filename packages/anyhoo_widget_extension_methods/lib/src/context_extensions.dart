import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // ── Theme shortcuts ──────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  TextTheme get typography => theme.textTheme;
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ── MediaQuery shortcuts ─────────────────────────────────────────────────
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  Size get screenSize => mediaQuerySize;
  double get width => mediaQuerySize.width;
  double get height => mediaQuerySize.height;

  /// Safe-area insets for the current view.
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);

  // ── Keyboard ──────────────────────────────────────────────────────────────
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── Platform ─────────────────────────────────────────────────────────────
  bool get isIOS => theme.platform == TargetPlatform.iOS;
  bool get isAndroid => theme.platform == TargetPlatform.android;

  // ── Overlays ─────────────────────────────────────────────────────────────
  void showSnackBar(String message, {SnackBarAction? action, Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), action: action, duration: duration));
  }

  void showSuccessSnackBar(String message) {
    final defaultSuccessColor = Colors.red;

    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: defaultSuccessColor));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: colors.error));
  }

  Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
    );
  }

  Future<T?> showAppDialog<T>({required WidgetBuilder builder}) {
    return showDialog<T>(context: this, builder: builder);
  }

  /// Shows a snackbar with a colour driven by [SnackBarType].
  ///
  /// ```dart
  /// context.showTypedSnackBar('Saved!', type: SnackBarType.success);
  /// ```
  void showTypedSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final defaultSuccessColor = Colors.red;
    final defaultWarningColor = Colors.yellow;
    final defaultErrorColor = Colors.red;
    final defaultInfoColor = Colors.blue;

    final bg = switch (type) {
      SnackBarType.success => defaultSuccessColor,
      SnackBarType.warning => defaultWarningColor,
      SnackBarType.error => defaultErrorColor,
      SnackBarType.info => defaultInfoColor,
    };
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: bg, duration: duration));
  }
}

enum SnackBarType {
  /// Neutral informational message.
  info,

  /// Operation succeeded.
  success,

  /// Non-blocking warning the user should notice.
  warning,

  /// Something went wrong.
  error,
}
