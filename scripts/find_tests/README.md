# Find Tests

A command-line tool for discovering and documenting all tests in a Flutter project. Scans for unit tests, Patrol integration tests, Firebase Functions tests, and Firestore rules tests, then writes a markdown summary to the project's `docs/` directory.

## Test Locations Scanned

| Category | Paths / Patterns |
|----------|------------------|
| Flutter unit/widget | `test/**/*_test.dart`, `packages/*/test/**/*_test.dart`, `tools/*/test/**/*_test.dart`, `scripts/*/test/**/*_test.dart` |
| Patrol integration | `patrol_test/**/*_test.dart` (or custom dir from `patrol.test_directory` in root pubspec) |
| Firebase Functions | `functions/**/*.test.ts`, `functions/**/*.spec.ts` |
| Firestore rules | `**/*.rules.test.ts`, `**/firestore*.test.ts` (Node.js describe/test) |

## Usage

From the target repository (after adding as dev dependency):

```bash
dart run find_tests --project-root=.
```

From the flutter_platform_kit directory:

```bash
cd scripts/find_tests
dart pub get
dart run find_tests --project-root=/path/to/target/repo
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--project-root=<path>` | Root of repo to scan | Current directory |
| `--output=<path>` | Output file path | `docs/tests.md` |
| `--quiet`, `-q` | Minimal output | `false` |
| `--help`, `-h` | Show usage | - |

### Examples

```bash
# Scan current directory, write to docs/tests.md
dart run find_tests

# Scan a specific repo
dart run find_tests --project-root=../my_flutter_app

# Custom output path
dart run find_tests --output=docs/testing-overview.md

# Quiet mode (for CI or scripts)
dart run find_tests --project-root=. --quiet
```

## Output

The tool writes a markdown file with:

- **Top level**: Test type (Flutter Unit/Widget, Patrol Integration, Firebase Functions, Firestore Rules)
- **Within each type**: Grouped by package or directory (e.g. `packages/anyhoo_auth`, `tools/freezed_to_ts`, `functions`)

Example structure:

```markdown
# Tests

## Flutter Unit/Widget Tests

### packages/anyhoo_core
- `packages/anyhoo_core/test/anyhoo_core_test.dart`
- `packages/anyhoo_core/test/utils/string_utils_test.dart`

### tools/freezed_to_ts
- `tools/freezed_to_ts/test/freezed_to_ts_test.dart`

## Patrol Integration Tests
*No tests found.*

...
```

## Adding as Dev Dependency

To run from another repository:

```yaml
# pubspec.yaml
dev_dependencies:
  find_tests:
    git:
      url: https://github.com/Anyhoosolutions/flutter_platform_kit.git
      path: scripts/find_tests
```

Then:

```bash
dart pub get
dart run find_tests --project-root=.
```

## Notes

- Excluded directories: `build/`, `.dart_tool/`, `node_modules/`
- Patrol test directory can be overridden in root `pubspec.yaml`:

  ```yaml
  patrol:
    test_directory: integration_test
  ```
