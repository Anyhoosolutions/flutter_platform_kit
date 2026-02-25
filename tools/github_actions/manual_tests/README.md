# Manual Tests Workflow

A reusable GitHub Actions workflow for running tests on demand with configurable branch/commit and test type selection.

## Features

- **Branch/commit selection**: Test any branch or specific commit SHA
- **Test type checkboxes**: Flutter unit tests, Patrol/integration tests, Firestore rules tests, Functions tests
- **Config-driven**: Paths and commands defined in `.github/tests-config.json`
- **No SOPS required**: Generates minimal `firebase_options.dart` for emulator-based tests

## Documentation

| Document | Description |
|----------|-------------|
| [CONFIG-REFERENCE.md](CONFIG-REFERENCE.md) | Complete `tests-config.json` field reference |

## Quick Start

### 1. Create the workflow file

Copy `manual-tests-workflow-template.yml` to `.github/workflows/manual-tests.yml` in your app repository.

### 2. Create the configuration file

Copy `tests-config-template.json` to `.github/tests-config.json` and customize:

```json
{
  "firebase_project_id": "demo-project-id",
  "flutter_unit_tests": {
    "packages": ["packages/*", "tools/*"],
    "command": "flutter test"
  },
  "patrol_integration_tests": {
    "type": "patrol",
    "directory": "patrol_test",
    "command": "patrol test"
  },
  "firestore_rules_tests": {
    "test_directory": "firestore.rules.test",
    "test_command": "npm test"
  },
  "functions_tests": {
    "path": "functions",
    "test_command": "npm test"
  }
}
```

### 3. Run tests

1. Go to Actions → Manual Tests
2. Click "Run workflow"
3. Optionally enter a branch name or commit SHA (empty = default branch)
4. Check the test types to run
5. Click "Run workflow"

## Test Types

| Type | Description |
|------|-------------|
| **Flutter unit tests** | Runs `flutter test` in packages matching the configured glob patterns |
| **Patrol / Integration** | Runs Patrol E2E tests or standard Flutter integration tests against emulators |
| **Firestore rules** | Runs Firestore security rules tests via `firebase emulators:exec --only firestore` |
| **Functions** | Runs Firebase Functions tests using the existing firebase-functions-test action |

## Firebase Options for Emulator Tests

Patrol and integration tests run against Firebase emulators. Instead of decrypting SOPS-encrypted `firebase_options.dart`, the workflow generates a minimal placeholder file at runtime with `projectId: demo-project-id` (or your configured `firebase_project_id`). No secrets required.

## Files in This Directory

| File | Description |
|------|-------------|
| `README.md` | This quick start guide |
| `CONFIG-REFERENCE.md` | Complete config field reference |
| `tests-config-template.json` | Template for `.github/tests-config.json` |
| `manual-tests-workflow-template.yml` | Template for `.github/workflows/manual-tests.yml` |
| `scripts/generate-firebase-options.sh` | Generates minimal firebase_options.dart for emulator tests |
