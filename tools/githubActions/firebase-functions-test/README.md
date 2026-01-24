# Firebase Functions Test Composite Action

A reusable GitHub Actions composite action for running tests on Firebase Functions using Firebase Emulators.

## Location

This action is located in `tools/githubActions/firebase-functions-test/` to make it easy to share across repositories.

## Features

- ✅ Sets up Node.js
- ✅ Sets up Java (required for Firebase Emulators)
- ✅ Installs Firebase Tools
- ✅ Installs dependencies
- ✅ Builds TypeScript/compiles code
- ✅ Runs tests using Firebase Emulators
- ✅ Configurable emulator setup

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-test@main
  with:
    firebase_project_id: "your-project-id"
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage

```yaml
name: Tests Firebase Functions

on:
  pull_request:
    branches: [main]

jobs:
  firebase-functions-tests:
    runs-on: ubuntu-latest
    # Skip if PR title contains "WIP: "
    if: ${{ !contains(github.event.pull_request.title, 'WIP') }}
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-test@main
        with:
          firebase_project_id: "your-project-id"
```

### Full Example with Custom Options

```yaml
name: Tests Firebase Functions

on:
  pull_request:
    branches: [main]

jobs:
  firebase-functions-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-test@main
        with:
          firebase_project_id: "your-project-id"
          functions_path: "functions"
          node_version: "20"
          java_version: "21"
          build_command: "npm run build"
          test_command: "npm test"
          emulators: "functions,firestore"
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `firebase_project_id` | Firebase project ID for emulator | Yes | - |
| `functions_path` | Path to the functions directory | No | `functions` |
| `node_version` | Node.js version to use | No | `20` |
| `java_version` | Java version to use | No | `21` |
| `java_distribution` | Java distribution to use | No | `temurin` |
| `install_command` | Command to install dependencies | No | `npm install` |
| `build_command` | Command to build TypeScript/compile code | No | `npm run build` |
| `test_command` | Command to run tests | No | `npm test` |
| `emulators` | Comma-separated list of emulators to start | No | `functions,firestore` |
| `firebase_auth_emulator_host` | Firebase Auth emulator host | No | `127.0.0.1:9099` |
| `firestore_emulator_host` | Firestore emulator host | No | `127.0.0.1:8080` |
| `firebase_functions_emulator_host` | Firebase Functions emulator host | No | `127.0.0.1:5001` |

## What This Action Does

1. **Sets up Node.js** - Installs the specified Node.js version
2. **Sets up Java** - Installs Java (required for Firebase Emulators)
3. **Installs Firebase Tools** - Installs `firebase-tools` globally
4. **Installs Dependencies** - Runs the install command in the functions directory
5. **Builds Code** - Compiles TypeScript/builds the code (if `build_command` is provided)
6. **Runs Tests** - Executes tests using Firebase Emulators with the specified configuration

## Customization

### Skip Build Step

```yaml
with:
  build_command: ""
```

### Different Package Manager

```yaml
with:
  install_command: "yarn install"
  build_command: "yarn build"
  test_command: "yarn test"
```

### Different Node.js Version

```yaml
with:
  node_version: "18"
```

### Different Java Version

```yaml
with:
  java_version: "17"
  java_distribution: "temurin"
```

### Custom Functions Directory

```yaml
with:
  functions_path: "backend/functions"
```

### Different Emulators

```yaml
with:
  emulators: "functions,firestore,auth"
```

### Custom Test Command

```yaml
with:
  test_command: "npm run test:unit"
```

## Requirements

- The functions directory must exist and contain a `package.json`
- Firebase project ID must be provided
- Java is required for Firebase Emulators (automatically set up by the action)
- Test scripts must be configured in `package.json`

## Environment Variables

The action automatically sets the following environment variables for the test run:

- `CI=true`
- `FIREBASE_AUTH_EMULATOR_HOST` (configurable)
- `FIRESTORE_EMULATOR_HOST` (configurable)
- `FIREBASE_FUNCTIONS_EMULATOR_HOST` (configurable)
- `GCLOUD_PROJECT` (from `firebase_project_id` input)
- `NODE_ENV=test`

## Notes

- The action uses Firebase Emulators to run tests in isolation
- All emulators are automatically started and stopped
- The build step can be skipped by setting `build_command: ""`
- The action fails if any step fails (build errors, test failures, etc.)
