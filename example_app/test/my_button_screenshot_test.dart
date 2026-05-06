import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  testWidgets('MyButton snapshot', (WidgetTester tester) async {
    final config = ScreenshotSurfaceConfig.fromEnvironment();
    await prepareScreenshotSurface(tester, config);

    await tester.pumpWidget(
      screenshotAppShell(
        config: config,
        child: RepaintBoundary(
          key: const Key('screenshot_subject'),
          child: FilledButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('screenshot_subject')),
      matchesGoldenFile('goldens/my_button.png'),
    );
  });
}
