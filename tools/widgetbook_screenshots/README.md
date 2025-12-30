# Widgetbook Screenshots Tool

A command-line tool to capture screenshots from a running Widgetbook instance and generate a navigation graph PNG showing the relationships between screens.

## Overview

This tool automates the process of:
1. Capturing screenshots from a running Widgetbook web instance
2. Saving individual screenshots to a directory
3. Generating a single PNG navigation graph with embedded screenshots and arrows showing navigation flow

## Prerequisites

- Dart SDK (>=3.0.0)
- Playwright CLI installed:
  ```bash
  npm install -g playwright
  playwright install chromium
  ```
- Widgetbook running on a local port (default: http://localhost:45678)

## Installation

### From GitHub

```bash
# Activate the tool globally
dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/widgetbook_screenshots

# Using a specific branch
dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/widgetbook_screenshots --git-ref main

# Using a tag/version
dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/widgetbook_screenshots --git-ref v0.1.0
```

### From Local Clone

```bash
cd tools/widgetbook_screenshots
dart pub get
dart run widgetbook_screenshots --help
```

## Configuration File Format

Create a JSON configuration file with the following structure:

```json
{
  "widgetbookUrl": "http://localhost:45678",
  "outputDir": "./screenshots",
  "cropGeometry": {
    "width": 515,
    "height": 1080,
    "xOffset": 700,
    "yOffset": 0
  },
  "screens": [
    {
      "name": "recipe_list",
      "title": "Recipe List",
      "path": "pages/recipe/recipelistpage/recipelistpage",
      "navigatesTo": ["recipe_details", "add_recipe"]
    },
    {
      "name": "recipe_details",
      "title": "Recipe Details",
      "path": "pages/recipe/recipedetailspage/recipedetailspage",
      "navigatesTo": ["edit_recipe"]
    },
    {
      "name": "add_recipe",
      "title": "Add Recipe",
      "path": "pages/recipe/addrecipepage/addrecipepage",
      "navigatesTo": ["recipe_list"]
    }
  ]
}
```

### Configuration Fields

- `widgetbookUrl` (optional): Base URL of the running Widgetbook instance (default: `http://localhost:45678`)
- `outputDir` (optional): Directory where screenshots will be saved (default: `./screenshots`)
- `cropGeometry` (optional): Crop geometry for screenshots. Since Widgetbook displays in the middle of the page, screenshots are automatically cropped:
  - `width` (optional): Width of the cropped area in pixels (default: `515`)
  - `height` (optional): Height of the cropped area in pixels (default: `1080`)
  - `xOffset` (optional): X offset from left edge in pixels (default: `700`)
  - `yOffset` (optional): Y offset from top edge in pixels (default: `0`)
- `screens` (required): Array of screen definitions:
  - `name` (required): Unique identifier for the screen (used as filename: `{name}.png`)
  - `title` (required): Display title for the screen
  - `path` (required): Widgetbook path/URL fragment (e.g., `pages/recipe/recipelistpage/recipelistpage`)
  - `navigatesTo` (optional): Array of screen names that this screen navigates to

## Usage

### Basic Usage

```bash
# Capture screenshots and generate navigation graph
widgetbook_screenshots --config config.json

# Specify custom output path for navigation graph
widgetbook_screenshots --config config.json --output ./output/navigation.png

# Skip screenshot capture (use existing screenshots)
widgetbook_screenshots --config config.json --skip-screenshots
```

### Command-Line Options

- `-c, --config`: (Required) Path to JSON configuration file
- `-o, --output`: (Optional) Output path for navigation graph PNG (default: `./navigation_graph.png`)
- `--skip-screenshots`: (Optional) Skip screenshot capture and use existing screenshots in output directory

## How It Works

1. **Screenshot Capture**: Uses Playwright CLI to navigate to each Widgetbook URL and capture a screenshot
2. **Graph Layout**: Automatically arranges screenshots in a left-to-right hierarchical layout based on navigation relationships
3. **PNG Generation**: Composites all screenshots onto a single canvas with arrows showing navigation flow

### Graph Layout Algorithm

- Uses a hierarchical left-to-right layout
- Automatically handles:
  - Multiple screens leading to one screen
  - One screen leading to multiple screens
  - Circular dependencies (breaks cycles by placing nodes in appropriate levels)
- Positions nodes to minimize edge crossings

## Example Workflow

1. Start Widgetbook in your project:
   ```bash
   cd your_project/widgetbook
   dart run build_runner build -d
   flutter run -d chrome --web-port=45678
   ```

2. Create a `config.json` file with your screen definitions

3. Run the tool:
   ```bash
   widgetbook_screenshots --config config.json --output ./docs/navigation.png
   ```

4. The tool will:
   - Capture screenshots to `./screenshots/` (or your configured `outputDir`)
   - Generate `navigation.png` with the navigation graph

## Output

- **Individual Screenshots**: Saved to the configured `outputDir` directory as `{name}.png`
- **Navigation Graph**: Single PNG file showing all screenshots arranged with navigation arrows

## Troubleshooting

### Playwright Not Found

If you see an error about Playwright not being found:
```bash
npm install -g playwright
playwright install chromium
```

### Screenshots Not Capturing

- Ensure Widgetbook is running and accessible at the configured URL
- Check that the paths in your config match your Widgetbook structure
- Verify Playwright can access the URL (try opening it in a browser)

### Graph Layout Issues

- The layout algorithm handles cycles automatically
- If nodes overlap, you may need to adjust the layout constants in `lib/src/graph_layout.dart`

## Development

To contribute or modify the tool:

```bash
cd tools/widgetbook_screenshots
dart pub get
dart analyze
dart test
```

## License

See the main repository LICENSE file.
