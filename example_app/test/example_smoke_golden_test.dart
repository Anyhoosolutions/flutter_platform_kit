import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  testWidgets('Golden smoke tile', (WidgetTester tester) async {
    final config = ScreenshotSurfaceConfig.fromEnvironment();
    await prepareScreenshotSurface(tester, config);

    await tester.pumpWidget(
      screenshotAppShell(
        config: config,
        child: RepaintBoundary(
          key: const Key('golden_smoke'),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 120,
              height: 48,
              color:
                  config.brightness == Brightness.dark ? Colors.lightBlue : Colors.blue,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('golden_smoke')),
      matchesGoldenFile('goldens/golden_smoke_tile.png'),
    );
  });
}
