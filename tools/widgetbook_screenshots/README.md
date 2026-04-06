# Widgetbook Screenshots Tool

A command-line tool focused on capturing screenshots from a running Widgetbook instance.

## Overview

This tool automates:
1. Opening Widgetbook story paths in a browser via Playwright
2. Capturing screenshots for each provided story path
3. Cropping to the desired viewport area
4. Optionally making phone corners transparent with a rounded-corner mask

## Prerequisites

- Dart SDK (>=3.0.0)
- Playwright CLI installed:
  ```bash
  npm install -g playwright
  playwright install chromium
  ```
- Widgetbook running locally (default port: `45678`)

## Installation

### From GitHub

```bash
dart pub global activate --source git https://github.com/anyhoosolutions/flutter_platform_kit.git --git-path tools/widgetbook_screenshots
```

### From Local Clone

```bash
cd tools/widgetbook_screenshots
dart pub get
dart run widgetbook_screenshots --help
```

## Usage

### Basic

```bash
widgetbook_screenshots /features/todos/allTodos/allTodosPage/default
```

### With Common Options

```bash
widgetbook_screenshots \
  --port 45678 \
  --device "iPhone 13" \
  --orientation portrait \
  --theme-mode dark \
  --output-dir ./screenshots \
  --crop-width 515 \
  --crop-height 1080 \
  --crop-x-offset 700 \
  --crop-y-offset 0 \
  --corner-radius 36 \
  /features/todos/allTodos/allTodosPage/default \
  /features/todos/userPreferences/default
```

### Incremental Capture

```bash
widgetbook_screenshots --skip-existing-screenshots /path/one /path/two
```

## Command-Line Options

- `--port`: Widgetbook port (default: `45678`)
- `--device`: Widgetbook knob value for `Device`
- `--orientation`: Widgetbook knob value for `Orientation` (`portrait`, `landscape`)
- `--theme-mode`: Widgetbook knob value for `Theme mode` (`light`, `dark`, `system`)
- `--output-dir`: Directory where screenshots are written (default: `./screenshots`)
- `--crop-width`: Crop width in pixels (default: `515`)
- `--crop-height`: Crop height in pixels (default: `1080`)
- `--crop-x-offset`: Crop X offset in pixels (default: `700`)
- `--crop-y-offset`: Crop Y offset in pixels (default: `0`)
- `--corner-radius`: Rounded corner radius in pixels (default: `0`, disabled)
- `--skip-existing-screenshots`: Skip stories that already have an output file
- `--debug` / `-d`: Verbose logging (prints the full Widgetbook URL and output path for each capture)

## Story Path Input

- Provide one or more story paths as positional arguments.
- Filenames are generated automatically from each path using a sanitized slug.
- Example:
  - input path: `/features/todos/allTodos/allTodosPage/default`
  - output file: `features_todos_alltodos_alltodospage_default.png`

## Output

- Individual screenshots are saved in `--output-dir`.
- One PNG is generated per provided story path.

## Troubleshooting

### Playwright Not Found

```bash
npm install -g playwright
playwright install chromium
```

### Screenshots Not Capturing

- Ensure Widgetbook is running on the expected port.
- Confirm each story path exists in Widgetbook.
- If using knobs, verify labels and values match your Widgetbook setup.

## Development

```bash
cd tools/widgetbook_screenshots
dart pub get
dart analyze
dart test
```

## License

See repository `LICENSE`.
