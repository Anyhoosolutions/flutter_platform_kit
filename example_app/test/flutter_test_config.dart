import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(
        obscureText: ScreenshotAlchemistFlags.ciObscureText,
      ),
    ),
    run: () async {
      await testMain();
    },
  );
}
