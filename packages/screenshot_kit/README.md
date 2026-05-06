# screenshot_kit

Shared helpers for **Flutter test** screenshots (golden PNGs): one set of **`--dart-define`** keys for viewport and theme, an optional **`screenshot_kit`** CLI (`flutter test` + collect PNGs under `**/goldens/`), and a hook for **[Alchemist](https://pub.dev/packages/alchemist)** `obscureText`.

---

## Quickstart — one golden PNG (vanilla Flutter, no Alchemist)

Follow these steps in **any Flutter app**.

A working copy of **Step 3** lives in this repo at [`example_app/test/my_button_screenshot_test.dart`](../../example_app/test/my_button_screenshot_test.dart) (adjust the `screenshot_kit` path in that app’s `pubspec.yaml`).

### Step 1 — Depend on `screenshot_kit`

In `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  screenshot_kit:
    path: ../flutter_platform_kit/packages/screenshot_kit   # adjust path / use git deps
```

Run:

```bash
flutter pub get
```

### Step 2 — Where files live

Golden paths are **relative to your test file’s folder**, not the project root.

Example layout:

| Path | Purpose |
|------|---------|
| `test/my_button_screenshot_test.dart` | Your test |
| `test/goldens/my_button.png` | Written by `--update-goldens` |

In code you use:

```dart
matchesGoldenFile('goldens/my_button.png');
```

Flutter creates **`test/goldens/my_button.png`** when the test file is `test/my_button_screenshot_test.dart`.

### Step 3 — Paste a minimal test

Create `test/my_button_screenshot_test.dart`:

```dart
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
```

- **`RepaintBoundary`** + a **`Key`** isolate what gets rasterised.
- **`prepareScreenshotSurface`** applies width/height/brightness/DPR from defines (see table below).
- **`screenshotAppShell`** wraps a **`MaterialApp`** with the right **`ThemeMode`**.

### Step 4 — Generate the PNG once

Always pass the **`.dart`** test path (never the `.png`):

```bash
flutter test --update-goldens test/my_button_screenshot_test.dart
```

This creates `test/goldens/my_button.png`.

### Step 5 — Verify (CI-style)

Without updating files:

```bash
flutter test test/my_button_screenshot_test.dart
```

Commit both the **`test/**/*.dart`** and **`test/**/goldens/*.png`** files.

### Step 6 (optional) — Same golden at another size/theme

Rebuild with defines (sizes must stay in sync with **`prepareScreenshotSurface`**):

```bash
flutter test --update-goldens \
  --dart-define=SCREENSHOT_LOGICAL_WIDTH=834 \
  --dart-define=SCREENSHOT_LOGICAL_HEIGHT=1194 \
  --dart-define=SCREENSHOT_BRIGHTNESS=dark \
  test/my_button_screenshot_test.dart
```

Or use this package’s CLI (from the **`screenshot_kit`** package folder, or [`dart pub global activate`](https://dart.dev/tools/pub/cmd/pub-global)):

```bash
dart run screenshot_kit \
  --directory . \
  --width 834 --height 1194 --brightness dark \
  --update-goldens \
  test/my_button_screenshot_test.dart
```

Collect copies of PNGs after a successful run:

```bash
dart run screenshot_kit \
  --directory . \
  --collect --output-dir ./dist/screenshots \
  test/my_button_screenshot_test.dart
```

---

## **`--dart-define` keys**

| Key | Meaning | Default |
|-----|---------|---------|
| `SCREENSHOT_LOGICAL_WIDTH` | Logical width (px) | `390` |
| `SCREENSHOT_LOGICAL_HEIGHT` | Logical height (px) | `844` |
| `SCREENSHOT_BRIGHTNESS` | `light` or `dark` | `light` |
| `SCREENSHOT_DEVICE_PIXEL_RATIO` | DPR | `1.0` |
| `SCREENSHOT_ALCHEMIST_OBSCURE_TEXT` | Alchemist [CiGoldensConfig.obscureText](https://pub.dev/documentation/alchemist/latest/alchemist/CiGoldensConfig-class.html): `false` ⇒ readable glyphs in CI goldens | `true` |

---

## Optional — Alchemist + readable CI text

`screenshot_kit` does **not** depend on Alchemist. Add **`alchemist`** to **`dev_dependencies`**, then in **`test/flutter_test_config.dart`**:

```dart
import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(
        obscureText: ScreenshotAlchemistFlags.ciObscureText,
      ),
    ),
    run: testMain,
  );
}
```

Readable CI glyphs:

```bash
flutter test --dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false
```

CLI shorthand:

```bash
dart run screenshot_kit --readable-alchemist-ci-text ...
```

**Vanilla tests** (`matchesGoldenFile` only) ignore `SCREENSHOT_ALCHEMIST_OBSCURE_TEXT`.

---

## Common mistakes

**Passing a `.png` to `flutter test`** — Arguments must be **`*.dart`**. Use:

`flutter test --update-goldens test/my_button_screenshot_test.dart`

Not `flutter test … test/goldens/my_button.png`.

If you see **“Failed to decode data using encoding 'utf-8'”** on a PNG path, you pointed the runner at an image instead of a test file.

**Readable vs blocked-out text**

- Vanilla **`matchesGoldenFile`**: no masking; fix theme/contrast if text disappears.
- **Alchemist CI goldens**: use `SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false` and the config above (or prefer platform goldens). Disabling obscure text increases **OS-dependent** drift.

---

## Implementation notes

- **CLI VM entrypoint**: [`screenshot_cli.dart`](lib/screenshot_cli.dart) (no Flutter imports) — use `dart run screenshot_kit`; full API — [`screenshot_kit.dart`](lib/screenshot_kit.dart).

## CI

Pin the **Flutter SDK** channel/version if snapshots must match across machines; golden pixels vary by renderer and OS.
