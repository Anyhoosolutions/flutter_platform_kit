import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

/// Minimal Alchemist golden for README (`flutter test`, define flags).
///
/// Generates files next to this test under `goldens/ci/` (and optionally
/// `goldens/<your_os>/` for platform snapshots when enabled).
void main() {
  final config = ScreenshotSurfaceConfig.fromEnvironment();

  goldenTest(
    'Readable label baseline',
    fileName: 'alchemist_readable_label',
    builder: () => GoldenTestGroup(
      scenarioConstraints: BoxConstraints.tightFor(
        width: config.logicalWidth.toDouble(),
        height: config.logicalHeight.toDouble(),
      ),
      children: [
        GoldenTestScenario(
          name: 'plain_text',
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Readable CI copy'),
          ),
        ),
      ],
    ),
  );
}
