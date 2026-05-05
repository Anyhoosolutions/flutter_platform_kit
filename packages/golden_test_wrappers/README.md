# golden_test_wrappers

Helpers for Flutter golden tests: fixed viewport, brightness, and documented `--dart-define` keys so CLI tools (see `tools/golden_screenshots`) and CI can drive the same dimensions as local runs.

## Setup

```yaml
dev_dependencies:
  golden_test_wrappers:
    path: ../flutter_platform_kit/packages/golden_test_wrappers
```

## Dart-define keys

| Key | Meaning | Default when omitted |
|-----|---------|----------------------|
| `GOLDEN_LOGICAL_WIDTH` | Surface width (logical px) | `390` |
| `GOLDEN_LOGICAL_HEIGHT` | Surface height (logical px) | `844` |
| `GOLDEN_BRIGHTNESS` | `light` or `dark` | `light` |
| `GOLDEN_DEVICE_PIXEL_RATIO` | DPR | `1.0` |

Pass additional defines (e.g. Alchemist) through `flutter test` / `golden_screenshots`; they are independent of this package:

```bash
flutter test --dart-define=ALCHEMIST_INCLUDE_PLATFORM_GOLDENS=true test/my_golden_test.dart
```

## Example test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_test_wrappers/golden_test_wrappers.dart';

void main() {
  testWidgets('MyWidget golden', (tester) async {
    final config = GoldenRunConfig.fromEnvironment();
    await configureGoldenSurface(tester, config);

    await tester.pumpWidget(
      goldenAppHost(
        config: config,
        child: RepaintBoundary(
          key: const Key('golden_subject'),
          child: const MyWidget(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('golden_subject')),
      matchesGoldenFile('goldens/my_widget.png'),
    );
  });
}
```

For Alchemist, wrap your scenario with the same `GoldenRunConfig.fromEnvironment()` values when configuring `goldenTest` / themes — this package stays framework-agnostic.
