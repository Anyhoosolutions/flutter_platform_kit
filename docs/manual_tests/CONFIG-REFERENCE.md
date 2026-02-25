# Tests Configuration Reference

Complete reference for `.github/tests-config.json` fields.

## Table of Contents

- [Global Settings](#global-settings)
- [flutter_unit_tests](#flutter_unit_tests)
- [patrol_integration_tests](#patrol_integration_tests)
- [firestore_rules_tests](#firestore_rules_tests)
- [functions_tests](#functions_tests)

---

## Global Settings

```json
{
  "flutter_version": "3.38.4",
  "flutter_channel": "stable",
  "firebase_project_id": "demo-project-id"
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `flutter_version` | string | No | `"3.38.4"` | Flutter SDK version |
| `flutter_channel` | string | No | `"stable"` | Flutter channel |
| `firebase_project_id` | string | No | `"demo-project-id"` | Used for Firestore rules, Functions tests, and generated firebase_options.dart |

---

## flutter_unit_tests

Configuration for Flutter unit tests (`flutter test`).

```json
{
  "flutter_unit_tests": {
    "packages": ["packages/*", "tools/*"],
    "command": "flutter test"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `packages` | array | No | `["."]` | Directories containing `pubspec.yaml` and `test/` (use `["."]` for single app, `["packages/*", "tools/*"]` for monorepos) |
| `command` | string | No | `"flutter test"` | Command to run in each package |

---

## patrol_integration_tests

Configuration for Patrol E2E tests or standard Flutter integration tests.

```json
{
  "patrol_integration_tests": {
    "type": "patrol",
    "directory": "patrol_test",
    "command": "patrol test",
    "app_directory": ".",
    "firebase_options_path": "lib/firebase_options.dart"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `type` | string | No | `"patrol"` | `"patrol"` or `"integration_test"` |
| `directory` | string | No | `"patrol_test"` | Test directory (e.g. `patrol_test`, `integration_test`) |
| `command` | string | No | `"patrol test"` | Command to run (e.g. `patrol test` or `flutter test integration_test`) |
| `app_directory` | string | No | `"."` | App root directory (for monorepos, e.g. `example_app`) |
| `firebase_options_path` | string | No | `"lib/firebase_options.dart"` | Path for generated firebase_options.dart (relative to repo root) |

---

## firestore_rules_tests

Configuration for Firestore security rules tests (Node.js with `@firebase/rules-unit-testing`).

```json
{
  "firestore_rules_tests": {
    "working_directory": ".",
    "rules_path": "firestore.rules",
    "test_directory": "firestore.rules.test",
    "test_command": "npm test"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `working_directory` | string | No | `"."` | Directory containing firebase.json (e.g. `example_app` for monorepos) |
| `rules_path` | string | No | `"firestore.rules"` | Path to rules file (from firebase.json) |
| `test_directory` | string | No | `"firestore-rules-test"` | Directory with `package.json` and test files (relative to working_directory) |
| `test_command` | string | No | `"npm test"` | Command to run (e.g. `npm test`) |

The test directory should have `package.json` with `@firebase/rules-unit-testing` and tests that use the Firestore emulator.

---

## functions_tests

Configuration for Firebase Functions tests. Reuses the firebase-functions-test action.

```json
{
  "functions_tests": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build",
    "test_command": "npm test",
    "emulators": "functions,firestore"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `path` | string | No | `"functions"` | Path to functions directory |
| `install_command` | string | No | `"npm install"` | Install dependencies |
| `build_command` | string | No | `"npm run build"` | Build/compile (empty to skip) |
| `test_command` | string | No | `"npm test"` | Test command |
| `emulators` | string | No | `"functions,firestore"` | Comma-separated emulators to start |

Uses `firebase_project_id` from global config for the emulator project.

---

## Complete Example

```json
{
  "flutter_version": "3.38.4",
  "flutter_channel": "stable",
  "firebase_project_id": "demo-project-id",

  "flutter_unit_tests": {
    "packages": ["packages/*", "tools/*"],
    "command": "flutter test"
  },

  "patrol_integration_tests": {
    "type": "patrol",
    "directory": "patrol_test",
    "command": "patrol test",
    "app_directory": ".",
    "firebase_options_path": "lib/firebase_options.dart"
  },

  "firestore_rules_tests": {
    "working_directory": ".",
    "rules_path": "firestore.rules",
    "test_directory": "firestore.rules.test",
    "test_command": "npm test"
  },

  "functions_tests": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build",
    "test_command": "npm test",
    "emulators": "functions,firestore"
  }
}
```
