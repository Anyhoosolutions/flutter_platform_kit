# Firebase Functions Quality Check Composite Action

A reusable GitHub Actions composite action for running linting and tests on Firebase Functions.

## Location

This action is located in `tools/githubActions/firebase-functions-quality/` to make it easy to share across repositories.

## Features

- ✅ Installs npm dependencies
- ✅ Runs linting (configurable, defaults to Biome)
- ✅ Runs tests (optional)
- ✅ Configurable paths and commands
- ✅ Handles Biome permissions automatically

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage (Linting Only)

```yaml
name: Code Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    # Skip if PR title contains "WIP: "
    if: ${{ !contains(github.event.pull_request.title, 'WIP') }}
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
```

### Full Example with Linting and Tests

```yaml
name: Code Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
        with:
          functions_path: "functions"
          run_lint: "true"
          lint_command: "npx @biomejs/biome ci ."
          run_tests: "true"
          test_command: "npm test"
```

### Custom Linter

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
  with:
    lint_command: "npm run lint"
```

### Different Functions Path

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
  with:
    functions_path: "firebase/functions"
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `functions_path` | Path to the functions directory | No | `functions` |
| `run_lint` | Whether to run linting | No | `true` |
| `lint_command` | Command to run for linting | No | `npx @biomejs/biome ci .` |
| `run_tests` | Whether to run tests | No | `false` |
| `test_command` | Command to run for tests | No | `npm test` |
| `install_command` | Command to install dependencies | No | `npm install` |

## What This Action Does

1. **Installs Dependencies** - Runs the install command (default: `npm install`) in the functions directory
2. **Fixes Biome Permissions** - Automatically fixes permissions for Biome CLI if using Biome (only if linting is enabled)
3. **Runs Linting** - Executes the lint command (default: `npx @biomejs/biome ci .`) if `run_lint: true`
4. **Runs Tests** - Executes the test command (default: `npm test`) if `run_tests: true`

## Customization

### Different Package Manager

```yaml
with:
  install_command: "yarn install"
  test_command: "yarn test"
```

### ESLint Instead of Biome

```yaml
with:
  lint_command: "npm run lint"
```

### Skip Linting, Only Run Tests

```yaml
with:
  run_lint: "false"
  run_tests: "true"
```

### Custom Functions Directory

```yaml
with:
  functions_path: "backend/functions"
```

## Requirements

- Node.js must be available (usually provided by the runner)
- The functions directory must exist and contain a `package.json`
- For linting: The linting tool must be configured in the functions directory
- For tests: Test scripts must be configured in `package.json`

## Notes

- The action automatically handles Biome CLI permissions on Linux
- All commands are run from within the functions directory
- The action fails if any step fails (linting errors, test failures, etc.)
- Dependencies are installed fresh on each run (no caching by default)
