# screenshot_kit

**Golden screenshots** with **[Alchemist](https://pub.dev/packages/alchemist)**, **`flutter test`**, and shared **`--dart-define`** flags. There is **no** separate `dart run …` tool—only the normal test runner.

Follow the steps in order.

---

### Step 1 — Dependencies

In **`pubspec.yaml`**:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  alchemist: ^0.14.0 # pin to your project standard
  screenshot_kit:
    path: ../packages/screenshot_kit # or pub.dev / git
```

---

### Step 2 — Fetch packages

```bash
flutter pub get
```

---

### Step 3 — (Optional) `dart_test.yaml` tag

At the **project root**, declaring Alchemist’s **`golden`** tag avoids analyzer/tooling noise:

```yaml
tags:
  golden:
```

Example: **`example_app/dart_test.yaml`**.

---

### Step 4 — Wire defines into Alchemist

Create **`test/flutter_test_config.dart`** (merge with an existing file if you already have one):

```dart
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
```

**`ScreenshotAlchemistFlags.ciObscureText`** reads **`SCREENSHOT_ALCHEMIST_OBSCURE_TEXT`**. If you **omit** that define, it behaves like **`true`** (masked CI text, Alchemist’s usual default).

---

### Step 5 — Write a golden test

Add a file such as **`test/my_widget_golden_test.dart`** (name must end with **`_test.dart`**).

```dart
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_kit/screenshot_kit.dart';
import 'package:your_app/my_widget.dart';

void main() {
  final config = ScreenshotSurfaceConfig.fromEnvironment();

  goldenTest(
    'My widget baseline',
    fileName: 'my_widget_golden',
    builder: () => GoldenTestGroup(
      // Use width + height from SCREENSHOT_LOGICAL_* defines.
      scenarioConstraints: BoxConstraints.tightFor(
        width: config.logicalWidth.toDouble(),
        height: config.logicalHeight.toDouble(),
      ),
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const MyWidget(),
        ),
      ],
    ),
  );
}
```

Copy-paste references in this repo: **`example_app/test/alchemist_readable_label_test.dart`**, **`example_app/test/error_page_demo_page_test.dart`**.

---

### Step 6 — Know where PNGs are stored

Next to the test file, Alchemist writes:

**`test/goldens/<environment>/<fileName>.png`**

Examples: **`goldens/ci/…`**, **`goldens/macos/…`** (host folder name varies). **`fileName`** is the **`goldenTest(..., fileName: 'slug')`** value—**no** `.png` suffix.

Always pass **`flutter test`** a **`.dart`** path, never a **`.png`**.

---

### Step 7 — Choose your `--dart-define` flags

Add **one** **`--dart-define=KEY=value`** per flag. Values are **strings** at compile time (`fromEnvironment`).

| Define | Values | If omitted | Applies to |
|--------|--------|------------|------------|
| **`SCREENSHOT_ALCHEMIST_OBSCURE_TEXT`** | **`true`** or **`false`** (lowercase) | same as **`true`** (masked CI text) | **Alchemist CI goldens** via Step 4 |
| `SCREENSHOT_LOGICAL_WIDTH` | integer `> 0` | `390` | **Alchemist scenario size** (Step 5) + `prepareScreenshotSurface` / `screenshotAppShell` |
| `SCREENSHOT_LOGICAL_HEIGHT` | integer `> 0` | `844` | same |
| `SCREENSHOT_BRIGHTNESS` | `light` or `dark` (case-insensitive) | `light` | `prepareScreenshotSurface` / `screenshotAppShell` |
| `SCREENSHOT_DEVICE_PIXEL_RATIO` | e.g. `1`, `2`, `2.5` | `1.0` | `prepareScreenshotSurface` / `screenshotAppShell` |

**Readable vs masked text on CI**

- **`--dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=true`** — CI goldens use masked glyphs (stable across machines).
- **`--dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false`** — CI goldens show real text (easier to review; can drift with OS/renderer).

**Rule:** use the **same** `SCREENSHOT_*` flags for **`flutter test --update-goldens`** as for normal **`flutter test`**. If you change flags, regenerate and commit new PNGs.

Example with several flags:

```bash
flutter test \
  --dart-define=SCREENSHOT_LOGICAL_WIDTH=834 \
  --dart-define=SCREENSHOT_LOGICAL_HEIGHT=1194 \
  --dart-define=SCREENSHOT_BRIGHTNESS=dark \
  --dart-define=SCREENSHOT_DEVICE_PIXEL_RATIO=2 \
  --dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false \
  test/my_widget_golden_test.dart
```

This repo’s **`example_app`** commits **readable** CI goldens, so its checks use **`SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false`**.

---

### Step 8 — Generate or refresh goldens

```bash
flutter test \
  --dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false \
  test/my_widget_golden_test.dart \
  --update-goldens
```

Adjust defines to match what you chose in Step 7, then commit the updated **`test/goldens/**`** files.

---

### Step 9 — Run tests (compare goldens)

Same command as Step 8 **without** **`--update-goldens`**:

```bash
flutter test \
  --dart-define=SCREENSHOT_ALCHEMIST_OBSCURE_TEXT=false \
  test/my_widget_golden_test.dart
```

---

## Common mistakes

- **`flutter test some_image.png`** — use a **`.dart`** test path only.
- **Golden mismatch after changing defines** — re-run Step 8 with the new flags and commit PNGs.
- **`SCREENSHOT_ALCHEMIST_OBSCURE_TEXT` seems ignored** — missing Step 4, or no **`goldenTest`** / Alchemist usage.
- **`Scaffold` / infinite height errors** — set **both** width and height in **`scenarioConstraints`** (see Step 5).

---

## Package exports

**`package:screenshot_kit/screenshot_kit.dart`** exposes **`ScreenshotSurfaceConfig`**, **`ScreenshotDefineKeys`**, **`ScreenshotAlchemistFlags`**, **`prepareScreenshotSurface`**, and **`screenshotAppShell`**. Use the surface helpers only in tests where you layout with those APIs; the steps above rely on **Alchemist** for goldens.

---

## CI

Pin the **Flutter SDK** version so golden pixels stay comparable across runners.
