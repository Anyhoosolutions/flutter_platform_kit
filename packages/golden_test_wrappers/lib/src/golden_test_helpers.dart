import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_run_config.dart';

/// Forces surface size, DPR, and platform brightness for stable goldens.
///
/// Call once per test before pumping widgets that depend on layout or theme.
Future<void> configureGoldenSurface(
  WidgetTester tester,
  GoldenRunConfig config,
) async {
  final binding = tester.binding;

  tester.view.devicePixelRatio = config.devicePixelRatio;
  await binding.setSurfaceSize(config.logicalSize);

  binding.platformDispatcher.platformBrightnessTestValue = config.brightness;
  addTearDown(() {
    binding.platformDispatcher.clearPlatformBrightnessTestValue();
  });
}

/// Minimal app shell for golden subjects — [ThemeMode] follows [config].
///
/// Override [light] / [dark] when your design system themes differ from
/// Material defaults.
Widget goldenAppHost({
  required Widget child,
  required GoldenRunConfig config,
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
