import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  test('buildFlutterTestArgs injects defines and update flag', () {
    expect(
      buildFlutterTestArgs(
        testArgs: ['test/smoke_test.dart'],
        width: 390,
        height: 844,
        brightness: 'dark',
        devicePixelRatio: 2,
        dartDefines: ['FOO=bar'],
        updateGoldens: true,
      ),
      [
        'test',
        'test/smoke_test.dart',
        '--dart-define=${ScreenshotDefineKeys.logicalWidth}=390',
        '--dart-define=${ScreenshotDefineKeys.logicalHeight}=844',
        '--dart-define=${ScreenshotDefineKeys.brightness}=dark',
        '--dart-define=${ScreenshotDefineKeys.devicePixelRatio}=2.0',
        '--dart-define=FOO=bar',
        '--update-goldens',
      ],
    );
  });
}
