import 'package:alchemist/alchemist.dart';
import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  final config = ScreenshotSurfaceConfig.fromEnvironment();

  goldenTest(
    'Error page demo baseline',
    fileName: 'error_page_demo_page',
    builder: () => GoldenTestGroup(
      scenarioConstraints: BoxConstraints.tightFor(
        width: config.logicalWidth.toDouble(),
        height: config.logicalHeight.toDouble(),
      ),
      children: [
        GoldenTestScenario(
          name: 'plain_text',
          child: const ErrorPageDemoPage(),
        ),
      ],
    ),
  );
}
