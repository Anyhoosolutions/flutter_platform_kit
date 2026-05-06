import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  test('alchemy flag key matches buildFlutterTestArgs readable mode', () {
    expect(
      buildFlutterTestArgs(
        testArgs: [],
        readableAlchemistCiGoldens: true,
      ),
      [
        'test',
        '--dart-define=${ScreenshotDefineKeys.alchemistObscureCiText}=false',
      ],
    );
  });
}
