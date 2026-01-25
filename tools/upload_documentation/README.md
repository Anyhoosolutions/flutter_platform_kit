# Documentation Uploader Tool

A command-line tool for uploading documentation to a documentation service. Reads documentation files from a `docs/` directory and uploads them via HTTP POST to a configurable endpoint.

## Features

- 📚 Reads documentation structure from `toc.json` and `metadata.yml`
- 📄 Processes all markdown files referenced in the table of contents
- 🔀 Supports branch-based deployments with commit hash prefixes
- 🌐 Configurable upload endpoint via environment variable
- 📦 Self-contained Dart package that can be used from any repository

## Prerequisites

- Dart SDK 3.5.2 or higher
- A `docs/` directory in your repository with:
  - `metadata.yml` - Project metadata and configuration
  - `toc.json` - Table of contents structure
  - Markdown files referenced in `toc.json`

## Setup

### Option 1: Clone the Repository (Recommended for Local Use)

Clone the `flutter_platform_kit` repository and use the tool:

```bash
# Clone the repository (if you haven't already)
git clone https://github.com/Anyhoosolutions/flutter_platform_kit.git
cd flutter_platform_kit/tools/upload_documentation

# Install dependencies
dart pub get
```

### Option 2: Use from GitHub in CI/CD

You can clone and use the tool directly in CI/CD workflows without maintaining a local copy.

## Usage

### Basic Usage

From your repository root (where the `docs/` directory is located):

```bash
# Set the upload URL
export UPLOAD_URL="https://your-documentation-service.com/upload"

# Run the tool (assumes current directory is project root)
cd /path/to/flutter_platform_kit/tools/upload_documentation
dart bin/upload_documentation.dart

# Or specify the project root explicitly
dart bin/upload_documentation.dart --projectRoot=/path/to/your/repo
```

### Branch-Based Deployment (PRs, etc.)

For branch-based deployments that use a commit hash:

```bash
export UPLOAD_URL="https://your-documentation-service.com/upload"
export GIT_COMMIT_HASH=$(git rev-parse HEAD)

dart bin/upload_documentation.dart --commitHash=$GIT_COMMIT_HASH
```

When `--commitHash` is provided:
- The tool treats it as a branch deployment
- Project name gets a commit hash suffix (first 7 characters)
- Project ID uses the full commit hash

### Command-Line Arguments

- `--projectRoot=<path>`: Specify the root directory of your project (defaults to current working directory)
- `--commitHash=<hash>`: Provide a commit hash for branch-based deployments

### Environment Variables

- `UPLOAD_URL` (required): The HTTP endpoint URL where documentation will be uploaded
  - Can also be set via `-DUPLOAD_URL=...` when running Dart
- `VERBOSE`: When set to `true` or `1`, prints the JSON payload before uploading (useful for debugging)
  - Example: `VERBOSE=1 dart bin/upload_documentation.dart --projectRoot=.`
  - Omit or leave unset for normal runs (e.g. in CI) to avoid noisy logs

## Project Structure

Your repository should have the following structure:

```
your-repo/
├── docs/
│   ├── metadata.yml          # Project metadata (required)
│   ├── toc.json              # Table of contents (required)
│   ├── main.md               # Documentation pages referenced in toc.json
│   └── other-pages.md
└── ...
```

### `docs/metadata.yml` Format

```yaml
projectId: "your-project-id"
name: "Your Project Name"
description: "Project description"
contactName: "Your Name"
contactEmail: "your.email@example.com"
allowedUsers:
  - "user1@example.com"
  - "user2@example.com"
```

**Note**: For branch deployments (when `--commitHash` is provided), the `projectId` in metadata is overridden with the commit hash, and the name gets a `-<short-hash>` suffix.

### `docs/toc.json` Format

The table of contents defines the structure of your documentation:

```json
{
  "filepath": "main.md",
  "name": "Main",
  "title": "Main Documentation",
  "onlyAllowedUsers": false,
  "subpages": [
    {
      "filepath": "getting-started.md",
      "name": "Getting Started",
      "title": "Getting Started Guide",
      "onlyAllowedUsers": false,
      "subpages": []
    },
    {
      "filepath": "internal/",
      "name": "Internal Docs",
      "title": "Internal Documentation",
      "onlyAllowedUsers": true,
      "subpages": [
        {
          "filepath": "internal/api.md",
          "name": "API",
          "title": "API Documentation",
          "onlyAllowedUsers": true,
          "subpages": []
        }
      ]
    }
  ]
}
```

**Important**:
- All `filepath` values must match actual markdown files in your `docs/` directory
- Directories (folders) should have `filepath` ending with `/`
- The `onlyAllowedUsers` flag determines if the page is restricted to users in `allowedUsers` from metadata

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Upload Documentation

on:
  push:
    branches: [main]
  pull_request:
    types: [opened, synchronize, reopened]

env:
  UPLOAD_URL: ${{ vars.UPLOAD_URL }}

jobs:
  upload-main:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Dart
        uses: dart-lang/setup-dart@v1
        with:
          sdk: "3.5"

      - name: Upload documentation
        run: |
          git clone --depth 1 --branch main https://github.com/Anyhoosolutions/flutter_platform_kit.git /tmp/flutter_platform_kit
          cd /tmp/flutter_platform_kit/tools/upload_documentation
          dart pub get
          dart bin/upload_documentation.dart --projectRoot=${{ github.workspace }}

  upload-branch:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request' || (github.event_name == 'push' && github.ref != 'refs/heads/main')
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Dart
        uses: dart-lang/setup-dart@v1
        with:
          sdk: "3.5"

      - name: Upload branch documentation
        run: |
          git clone --depth 1 --branch main https://github.com/Anyhoosolutions/flutter_platform_kit.git /tmp/flutter_platform_kit
          cd /tmp/flutter_platform_kit/tools/upload_documentation
          dart pub get
          export GIT_COMMIT_HASH=$(git rev-parse HEAD)
          dart bin/upload_documentation.dart --projectRoot=${{ github.workspace }} --commitHash=$GIT_COMMIT_HASH
```

### GitLab CI Example

```yaml
upload-docs:
  stage: deploy
  image: dart:stable
  variables:
    UPLOAD_URL: $UPLOAD_URL  # Set in GitLab CI/CD variables
  script:
    - git clone --depth 1 --branch main https://github.com/Anyhoosolutions/flutter_platform_kit.git /tmp/flutter_platform_kit
    - cd /tmp/flutter_platform_kit/tools/upload_documentation
    - dart pub get
      - |
      if [ "$CI_COMMIT_BRANCH" = "$CI_DEFAULT_BRANCH" ]; then
        dart bin/upload_documentation.dart --projectRoot=$CI_PROJECT_DIR
      else
        dart bin/upload_documentation.dart --projectRoot=$CI_PROJECT_DIR --commitHash=$CI_COMMIT_SHA
      fi
```

### Creating a Convenience Script

You can create a wrapper script in your repository for easier local use:

**`scripts/upload-docs.sh`**:
```bash
#!/bin/bash
set -e

# Get the project root (directory containing this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Clone or use existing flutter_platform_kit
TOOL_DIR="$PROJECT_ROOT/.tools/flutter_platform_kit/tools/upload_documentation"

if [ ! -d "$TOOL_DIR" ]; then
  echo "📦 Cloning flutter_platform_kit..."
  mkdir -p "$(dirname "$TOOL_DIR")"
  git clone --depth 1 --branch main https://github.com/Anyhoosolutions/flutter_platform_kit.git "$(dirname "$TOOL_DIR")"
fi

cd "$TOOL_DIR"
dart pub get

# Check if commit hash should be used (for non-main branches)
if [ -n "$1" ] && [ "$1" = "--branch" ]; then
  COMMIT_HASH=$(cd "$PROJECT_ROOT" && git rev-parse HEAD)
  echo "🔀 Uploading branch documentation with commit: $COMMIT_HASH"
  dart bin/upload_documentation.dart --projectRoot="$PROJECT_ROOT" --commitHash="$COMMIT_HASH"
else
  echo "📚 Uploading main documentation"
  dart bin/upload_documentation.dart --projectRoot="$PROJECT_ROOT"
fi
```

Make it executable:
```bash
chmod +x scripts/upload-docs.sh
```

Then use it:
```bash
# For main branch
./scripts/upload-docs.sh

# For branch/PR deployments
./scripts/upload-docs.sh --branch
```

## Error Handling

The tool will fail with an error message if:

- `docs/metadata.yml` is missing or invalid
- `docs/toc.json` is missing or invalid
- A markdown file referenced in `toc.json` doesn't exist
- `UPLOAD_URL` environment variable is not set
- The upload HTTP request fails (non-200 status code)
- The project root directory doesn't exist or doesn't contain a `docs/` directory

## Troubleshooting

### "Error reading file: ..."

This usually means a file path in `toc.json` doesn't match an actual file in your `docs/` directory. Check:
- File paths are relative to the `docs/` directory
- File paths match exactly (case-sensitive)
- All referenced files exist

### "UPLOAD_URL has not been set"

Make sure the `UPLOAD_URL` environment variable is set before running the tool:
```bash
export UPLOAD_URL="https://your-service.com/upload"
```

### "Couldn't find ToC Item: ..."

This means a markdown file exists in your `docs/` directory but is not referenced in `toc.json`. Either:
- Add it to `toc.json`, or
- Remove it from the `docs/` directory

### Upload fails with HTTP error

Check:
- The `UPLOAD_URL` is correct and accessible
- The endpoint accepts POST requests with `Content-Type: application/json`
- The service is running and healthy
- Check the response body in the error message for details

### Inspecting the JSON payload

To see the exact JSON sent to the upload endpoint (e.g. when debugging or verifying structure):

```bash
VERBOSE=1 dart bin/upload_documentation.dart --projectRoot=/path/to/your/repo
```

or `VERBOSE=true`. Leave `VERBOSE` unset in CI so logs stay clean.

## Development

To work on this tool locally:

```bash
cd tools/upload_documentation
dart pub get
dart pub run build_runner build  # Generate freezed/json_serializable code
dart analyze
dart test
```

## License

This tool is part of the flutter_platform_kit project and follows the same license.
