# Verify TypeScript Generation Composite Action

A reusable GitHub Actions composite action for verifying that TypeScript files generated from Dart freezed models are up to date.

## Location

This action is located in `tools/githubActions/verify-ts-generation/` to make it easy to share across repositories.

## Features

- ✅ Checks for changes in source or generated models (skips if no changes)
- ✅ Sets up Flutter, Node.js, and Java
- ✅ Generates TypeScript from freezed models
- ✅ Verifies generated files are up to date (no uncommitted changes)
- ✅ Verifies all generated files exist for source models
- ✅ Configurable paths and versions

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/verify-ts-generation@main
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage

```yaml
name: Verify TypeScript Generation from Freezed

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  verify-ts-generation:
    runs-on: ubuntu-latest
    # Skip if PR title contains "WIP: "
    if: ${{ !contains(github.event.pull_request.title, 'WIP') || github.event_name == 'push' }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for git diff
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/verify-ts-generation@main
```

### Full Example with Custom Options

```yaml
name: Verify TypeScript Generation from Freezed

on:
  pull_request:
    branches: [main]

jobs:
  verify-ts-generation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/verify-ts-generation@main
        with:
          source_models_path: "lib/sharedModels"
          generated_models_path: "functions/src/generatedModels"
          generation_script_path: "scripts/generate-ts-from-freezed.sh"
          flutter_version: "3.38.4"
          node_version: "22"
          java_version: "21"
          check_for_changes: "true"
          exclude_patterns: "*.freezed.dart *.g.dart"
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `source_models_path` | Path to source Dart models directory | No | `lib/sharedModels` |
| `generated_models_path` | Path to generated TypeScript models directory | No | `functions/src/generatedModels` |
| `generation_script_path` | Path to the generation script | No | `scripts/generate-ts-from-freezed.sh` |
| `flutter_version` | Flutter version to use | No | `3.38.4` |
| `flutter_channel` | Flutter channel to use | No | `stable` |
| `node_version` | Node.js version to use | No | `22` |
| `java_version` | Java version to use | No | `21` |
| `java_distribution` | Java distribution to use | No | `temurin` |
| `check_for_changes` | Whether to check for changes before running | No | `true` |
| `exclude_patterns` | Space-separated patterns to exclude when checking changes | No | `*.freezed.dart *.g.dart` |

## What This Action Does

1. **Checks for Changes** (if enabled) - Compares source and generated directories against base branch to skip if no changes
2. **Sets up Environment** - Installs Flutter, Node.js, and Java
3. **Gets Dependencies** - Runs `flutter pub get`
4. **Generates TypeScript** - Executes the generation script
5. **Verifies Files are Up to Date** - Checks that generated files match what's committed (no uncommitted changes)
6. **Verifies Files Exist** - Ensures all source models have corresponding generated TypeScript files
7. **Shows Diff on Failure** - Displays detailed differences if verification fails

## Customization

### Different Paths

```yaml
with:
  source_models_path: "packages/models/lib"
  generated_models_path: "backend/src/generated"
```

### Different Flutter Version

```yaml
with:
  flutter_version: "3.24.0"
  flutter_channel: "stable"
```

### Always Run (Don't Check for Changes)

```yaml
with:
  check_for_changes: "false"
```

### Custom Generation Script

```yaml
with:
  generation_script_path: "tools/generate-typescript.sh"
```

### Different Exclude Patterns

```yaml
with:
  exclude_patterns: "*.generated.dart *.freezed.dart *.g.dart"
```

## Requirements

- The source models directory must exist
- The generation script must exist and be executable
- Flutter, Node.js, and Java are required (automatically set up by the action)
- Git history must be available (use `fetch-depth: 0` in checkout)

## Notes

- The action automatically skips if no changes are detected (when `check_for_changes: true`)
- The action compares against PR base branch for PRs, or previous commit for pushes
- Generated files are checked for uncommitted changes using `git diff`
- The action provides clear error messages and instructions for fixing issues
- All steps are conditional on changes being detected (if change checking is enabled)
