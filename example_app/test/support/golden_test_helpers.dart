import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void appGoldenTest({
  required String description,
  required String fileName,
  required Widget child,
  String scenarioName = 'default',
}) {
  final config = ScreenshotSurfaceConfig.fromEnvironment();

  goldenTest(
    description,
    fileName: fileName,
    builder: () => GoldenTestGroup(
      scenarioConstraints: BoxConstraints.tightFor(
        width: config.logicalWidth.toDouble(),
        height: config.logicalHeight.toDouble(),
      ),
      children: [
        GoldenTestScenario(
          name: scenarioName,
          child: child,
        ),
      ],
    ),
  );
}
