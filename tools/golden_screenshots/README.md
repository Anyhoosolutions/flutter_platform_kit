# golden_screenshots

Runs `flutter test` with consistent `--dart-define` keys used by [`golden_test_wrappers`](../../packages/golden_test_wrappers), and optionally copies generated PNGs from any `goldens/` directory tree.

## Install

### From this repository

```bash
cd tools/golden_screenshots
dart pub get
dart run golden_screenshots --help
```

### Global (git dependency)

```bash
dart pub global activate --source git https://github.com/anyhoosolutions/flutter_platform_kit.git --git-path tools/golden_screenshots
```

## Usage

```bash
golden_screenshots \
  --directory /path/to/flutter_app \
  --width 390 \
  --height 844 \
  --brightness dark \
  --dart-define=ALCHEMIST_INCLUDE_PLATFORM_GOLDENS=true \
  test/goldens/my_test.dart
```

After a successful run, collect PNGs into a folder:

```bash
golden_screenshots \
  -C /path/to/flutter_app \
  --collect \
  --output-dir ./dist/golden_pngs \
  test/goldens/my_test.dart
```

### Options

| Flag | Purpose |
|------|---------|
| `-C`, `--directory` | Package root for `flutter test` (default: `.`) |
| `--width` / `--height` | Sets `GOLDEN_LOGICAL_WIDTH` / `GOLDEN_LOGICAL_HEIGHT` |
| `--brightness` | `light` or `dark` → `GOLDEN_BRIGHTNESS` |
| `--device-pixel-ratio` | → `GOLDEN_DEVICE_PIXEL_RATIO` |
| `--dart-define` | Repeatable `KEY=value` (passed through to `flutter test`) |
| `--update-goldens` | Forwards Flutter’s `--update-goldens` |
| `--collect` | Copy `**/goldens/**/*.png` after success |
| `--output-dir` | Required with `--collect` |
| `--goldens-root` | Limit search to this directory (default: package directory) |
| `--flat` | Flatten filenames; errors if basenames collide |

Positional arguments are forwarded to `flutter test` after the `test` subcommand (the tool always invokes `flutter test <your args>`).

## Troubleshooting

- **`flutter` not found**: install Flutter or set `FLUTTER_ROOT` so `bin/flutter` exists.
- **No PNGs collected**: run with `--update-goldens` first, or confirm golden files live under a folder named `goldens`.

## Development

```bash
cd tools/golden_screenshots
dart pub get
dart analyze
dart test
```

## License

See repository `LICENSE`.
