import 'package:golden_screenshots/golden_screenshots.dart';
import 'package:test/test.dart';

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
        '--dart-define=$goldenLogicalWidth=390',
        '--dart-define=$goldenLogicalHeight=844',
        '--dart-define=$goldenBrightness=dark',
        '--dart-define=$goldenDevicePixelRatio=2.0',
        '--dart-define=FOO=bar',
        '--update-goldens',
      ],
    );
  });
}
