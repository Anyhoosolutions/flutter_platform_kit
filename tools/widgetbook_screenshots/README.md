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

# Skip only existing screenshots (capture missing ones)
widgetbook_screenshots --config config.json --skip-existing-screenshots

# Capture screenshots in dark mode
widgetbook_screenshots --config config.json --dark-mode
```

### Command-Line Options

- `-c, --config`: (Required) Path to JSON configuration file
- `-o, --output`: (Optional) Output path for navigation graph PNG (default: `./navigation_graph.png`)
- `--skip-screenshots`: (Optional) Skip all screenshot capture and use existing screenshots in output directory
- `--skip-existing-screenshots`: (Optional) Skip screenshot capture only if file already exists (capture missing screenshots)
- `--dark-mode`: (Optional) Capture screenshots in dark mode. Appends dark mode knobs to Widgetbook URLs and adds `-dark` suffix to filenames

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
- **Branch Separation**: Automatically identifies separate navigation paths from root nodes and visually separates them:
  - Groups nodes by their branch/path for better visual organization
  - Adds extra vertical spacing between different branches
  - Creates parallel horizontal lanes for each branch to improve readability
  - Makes it easier to follow independent navigation flows
- Positions nodes to minimize edge crossings
- Centers all levels around a common midpoint for balanced layout

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
   - Automatically organize screens into separate branches for better visual clarity

### Incremental Updates

To update only missing screenshots without re-capturing existing ones:

```bash
widgetbook_screenshots --config config.json --skip-existing-screenshots
```

This is useful when:
- Adding new screens to your navigation flow
- Some screenshots failed to capture initially
- You want to preserve existing screenshots while capturing new ones

### Dark Mode Support

Capture screenshots in dark mode using the `--dark-mode` flag:

```bash
widgetbook_screenshots --config config.json --dark-mode
```

When dark mode is enabled:
- Widgetbook URLs are modified to include `&knobs={Theme%20mode:dark}` parameter
- Individual screenshot files are saved with `-dark` suffix (e.g., `recipe_list-dark.png`)
- Navigation graph output file is saved with `-dark` suffix (e.g., `navigation_graph-dark.png`)

This allows you to maintain both light and dark mode versions of your screenshots and navigation graphs without overwriting each other.

**Example workflow for both modes:**

```bash
# Capture light mode screenshots
widgetbook_screenshots --config config.json --output ./docs/navigation_graph.png

# Capture dark mode screenshots
widgetbook_screenshots --config config.json --dark-mode --output ./docs/navigation_graph.png
# This will create navigation_graph-dark.png and screenshots with -dark suffix
```

## Output

- **Individual Screenshots**: Saved to the configured `outputDir` directory as `{name}.png` (or `{name}-dark.png` when using `--dark-mode`)
- **Navigation Graph**: Single PNG file showing all screenshots arranged with navigation arrows (saved as `navigation_graph-dark.png` when using `--dark-mode`)

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
