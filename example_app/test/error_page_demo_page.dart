import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  testWidgets('ErrorPageDemoPage snapshot', (WidgetTester tester) async {
    final config = ScreenshotSurfaceConfig.fromEnvironment();
    await prepareScreenshotSurface(tester, config);

    await tester.pumpWidget(
      screenshotAppShell(
        config: config,
        child: RepaintBoundary(key: const Key('screenshot_subject'), child: ErrorPageDemoPage()),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('screenshot_subject')),
      matchesGoldenFile('goldens/error_page_demo_page.png'),
    );
  });
}
