# Check Version Composite Action

A reusable GitHub Actions composite action for checking if a version has been updated in a pull request compared to the base branch.

## Location

This action is located in `tools/github_actions/check-version/` to make it easy to share across repositories.

## Features

- ✅ Compares version between PR branch and base branch
- ✅ Supports multiple version file formats (pubspec.yaml, package.json, etc.)
- ✅ Configurable version extraction pattern
- ✅ Works with any base branch (defaults to PR base branch or main)

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/check-version@main
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage (Flutter/Dart with pubspec.yaml)

```yaml
name: Check Version

on:
  pull_request:
    branches: [main]

jobs:
  check-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/check-version@main
```

### Full Example with Custom Options

```yaml
name: Check Version

on:
  pull_request:
    branches: [main]

jobs:
  check-version:
    runs-on: ubuntu-latest
    # Skip if PR title contains "WIP: "
    if: ${{ !contains(github.event.pull_request.title, 'WIP') }}
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/check-version@main
        with:
          base_branch: "main"  # Optional: defaults to PR base branch
          version_file: "pubspec.yaml"
          version_pattern: "version:"
          fail_if_same: "true"
```

### Usage with package.json (Node.js)

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/check-version@main
  with:
    version_file: "package.json"
    version_pattern: '"version":'
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `base_branch` | Base branch to compare against | No | PR base branch or `main` |
| `version_file` | Path to the version file | No | `pubspec.yaml` |
| `version_pattern` | Pattern to extract version | No | `version:` |
| `fail_if_same` | Whether to fail if version is the same | No | `true` |

## How It Works

1. **Determines base branch**: Uses the provided `base_branch`, or the PR's base branch, or defaults to `main`
2. **Checks out base branch**: Clones the base branch to a `base/` directory
3. **Extracts versions**: Extracts version from both current branch and base branch using the specified pattern
4. **Compares versions**: Compares the versions and fails if they're the same (unless `fail_if_same: false`)

## Version File Examples

### pubspec.yaml (Flutter/Dart)
```yaml
version: 1.2.3
```
Pattern: `version:`

### package.json (Node.js)
```json
{
  "version": "1.2.3"
}
```
Pattern: `"version":`

### Cargo.toml (Rust)
```toml
version = "1.2.3"
```
Pattern: `version =`

### setup.py (Python)
```python
version = "1.2.3"
```
Pattern: `version =`

## Customization

### Different Base Branch

```yaml
with:
  base_branch: "develop"
```

### Warning Instead of Failure

```yaml
with:
  fail_if_same: "false"
```

### Custom Version File Location

```yaml
with:
  version_file: "packages/my_package/pubspec.yaml"
```

## Requirements

- The version file must exist in both the current branch and the base branch
- The version pattern must match the format in your version file
- The action requires `actions/checkout@v4` to be run before it

## Notes

- The action automatically trims whitespace from extracted versions
- If multiple lines match the pattern, only the first match is used
- The action provides clear error messages if versions are the same or files are missing
