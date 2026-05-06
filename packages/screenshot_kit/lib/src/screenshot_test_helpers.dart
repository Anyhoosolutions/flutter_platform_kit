import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'screenshot_surface_config.dart';

/// Sets surface size, DPR, and platform brightness before you pump widgets.
Future<void> prepareScreenshotSurface(
  WidgetTester tester,
  ScreenshotSurfaceConfig config,
) async {
  final binding = tester.binding;

  tester.view.devicePixelRatio = config.devicePixelRatio;
  await binding.setSurfaceSize(config.logicalSize);

  binding.platformDispatcher.platformBrightnessTestValue = config.brightness;
  addTearDown(() {
    binding.platformDispatcher.clearPlatformBrightnessTestValue();
  });
}

/// Minimal [MaterialApp] shell — [ThemeMode] follows [config].
Widget screenshotAppShell({
  required Widget child,
  required ScreenshotSurfaceConfig config,
  ThemeData? light,
  ThemeData? dark,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: light ?? ThemeData.light(useMaterial3: true),
    darkTheme: dark ?? ThemeData.dark(useMaterial3: true),
    themeMode: config.themeMode,
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}
