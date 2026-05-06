# screenshot_kit

Small shared helpers for **Flutter test** screenshot / golden PNGs: one set of `--dart-define` keys for viewport and theme, plus an optional **`screenshot_kit` CLI** that runs `flutter test` and can copy files from `**/goldens/**/*.png`.

Add it once per app (path or git); consumers write their own `testWidgets` + `matchesGoldenFile` — this package only standardizes surface setup and runner flags.

## Setup

```yaml
dev_dependencies:
  screenshot_kit:
    path: ../flutter_platform_kit/packages/screenshot_kit
```

## Dart-define keys

| Key | Meaning | Default |
|-----|---------|---------|
| `SCREENSHOT_LOGICAL_WIDTH` | Logical width (px) | `390` |
| `SCREENSHOT_LOGICAL_HEIGHT` | Logical height (px) | `844` |
| `SCREENSHOT_BRIGHTNESS` | `light` or `dark` | `light` |
| `SCREENSHOT_DEVICE_PIXEL_RATIO` | DPR | `1.0` |

## Example test

```dart
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
        child: RepaintBoundary(
          key: const Key('shot'),
          child: const MyWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('shot')),
      matchesGoldenFile('goldens/my_widget.png'),
    );
  });
}
```

## Commands

```bash
flutter test
flutter test --update-goldens test/my_test.dart
```

With defines:

```bash
flutter test \
  --dart-define=SCREENSHOT_LOGICAL_WIDTH=834 \
  --dart-define=SCREENSHOT_LOGICAL_HEIGHT=1194 \
  --dart-define=SCREENSHOT_BRIGHTNESS=dark \
  test/my_test.dart
```

## Bundled CLI

The executable uses [`screenshot_cli.dart`](lib/screenshot_cli.dart) (no Flutter imports) so `dart run` works on the Dart VM. Full helpers live in [`screenshot_kit.dart`](lib/screenshot_kit.dart).

From this package directory (or after `dart pub global activate` with `--git-path packages/screenshot_kit`):

```bash
dart run screenshot_kit \
  --directory /path/to/app \
  --width 390 --height 844 --brightness dark \
  --collect --output-dir ./dist/screenshots \
  test/my_test.dart
```

The CLI forwards the same `SCREENSHOT_*` defines as the table above and optionally copies PNGs after a successful run.

## CI note

Golden pixels can differ by OS and Flutter version — pin the Flutter SDK in CI if snapshots must be stable.
