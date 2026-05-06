import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  testWidgets('MyWidget screenshot', (tester) async {
    final config = ScreenshotSurfaceConfig.fromEnvironment();
    await prepareScreenshotSurface(tester, config);

    await tester.pumpWidget(
      screenshotAppShell(
        config: config,
        child: RepaintBoundary(key: const Key('shot'), child: const Text('Hello, world!')),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(find.byKey(const Key('shot')), matchesGoldenFile('goldens/my_widget.png'));
  });
}
