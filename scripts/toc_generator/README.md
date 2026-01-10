# TOC Generator

A command-line tool for generating `toc.json` by automatically scanning the `packages/` and `tools/` directories for documentation files.

## Usage

From the project root:

```bash
cd scripts/toc_generator
dart pub get
dart bin/generate_toc.dart
```

Or from anywhere:

```bash
cd /path/to/flutter_platform_kit/scripts/toc_generator
dart pub get
dart bin/generate_toc.dart
```

The script will:
1. Scan `packages/` and `tools/` directories
2. Find all packages/tools with `README.md` files
3. Find additional documentation files (`CHANGELOG.md`, files in `docs/` directories, and other `.md` files in package roots)
4. Update the `docs/toc.json` file with the discovered documentation structure

## How it works

The generator:
- Preserves the existing `toc.json` structure
- Updates the `flutter_packages.md` and `tools.md` sections with current packages
- Automatically organizes documentation files into the table of contents
- Sorts packages alphabetically
- Places CHANGELOGs first within each package section

## Requirements

- Dart SDK 3.5.2 or higher
- An existing `docs/toc.json` file (the script will preserve its top-level structure)

## Note

This tool only generates the TOC file. To upload documentation, use the `tools/upload_documentation` tool.
