# Build and Deploy Flutter APK Composite Action

A reusable GitHub Actions composite action for building Flutter APK files and deploying them to Firebase App Distribution.

## Location

This action is located in `tools/githubActions/build-deploy-flutter-apk/` to make it easy to share across repositories.

## Features

- ✅ Builds Flutter APK with configurable flavor and target
- ✅ Caches Gradle dependencies for faster builds
- ✅ Extracts Firebase Android App ID from firebase.json
- ✅ Deploys to Firebase App Distribution
- ✅ Conditional deployment based on changed files (perfect for multiple flavors)
- ✅ Supports release notes from file or text
- ✅ Distributes to groups and/or individual testers

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "shucked"
    groups: "testers"
  env:
    GOOGLE_APPLICATION_CREDENTIALS: ${{ github.workspace }}/firebase_service_account.json
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage

```yaml
- name: Set up Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: "3.38.4"

- name: Build and deploy APK
  uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "shucked"
    groups: "testers"
```

### With Release Notes File

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/shucked/main/main.dart"
    flavor: "shucked"
    release_notes_file: "deploy/release_notes.txt"
    groups: "testers,qa"
```

### With Custom App ID

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    firebase_app_id: "1:123456789:android:abcdef123456"
    groups: "testers"
```

### Build Only (No Deployment)

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    deploy: "false"
```

### Multiple Flavors

```yaml
# Build and deploy production flavor
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "production"
    groups: "production-testers"

# Build and deploy staging flavor
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "staging"
    groups: "staging-testers"
```

### Conditional Deployment Based on Changed Files

Deploy only when specific files or directories have changed. This is especially useful when you have multiple flavors and want to deploy each flavor only when its relevant files change:

```yaml
# Deploy production flavor only if production-specific files changed
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "production"
    groups: "production-testers"
    deploy_trigger_paths: |
      lib/flavors/production/
      android/app/src/production/
      pubspec.yaml

# Deploy staging flavor only if staging-specific files changed
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/build-deploy-flutter-apk@main
  with:
    target_file: "lib/main.dart"
    flavor: "staging"
    groups: "staging-testers"
    deploy_trigger_paths: |
      lib/flavors/staging/
      android/app/src/staging/
      pubspec.yaml
```

When `deploy_trigger_paths` is provided:
- The action checks if any files matching the specified paths have changed (compared to the base branch for PRs, or previous commit for pushes)
- Deployment only occurs if changes are detected in the watched paths
- If `deploy_trigger_paths` is empty or not provided, deployment behavior is unchanged (controlled by the `deploy` input)

## Inputs

### Build Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `target_file` | Target Dart file to build | Yes | - |
| `flavor` | Build flavor (e.g., shucked, production) | No | `""` |
| `build_mode` | Build mode (release, debug, profile) | No | `release` |
| `build_args` | Additional arguments for flutter build apk | No | `""` |
| `apk_output_path` | Path to the built APK file | No | `build/app/outputs/apk/release/app-release.apk` |
| `cache_gradle` | Whether to cache Gradle dependencies | No | `true` |

### Firebase App ID Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `firebase_app_id` | Firebase Android App ID (if not provided, extracted from firebase.json) | No | `""` |
| `firebase_json_path` | Path to firebase.json file | No | `firebase.json` |
| `app_id_path` | Path in firebase.json to extract app ID | No | `flutter.platforms.android.default.appId` |

### Deployment Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `deploy` | Whether to deploy to Firebase App Distribution | No | `true` |
| `deploy_trigger_paths` | Newline-separated list of paths/patterns that should trigger deployment. If provided, deployment only occurs if files matching these paths have changed. If empty, deployment happens based on `deploy` input only. | No | `""` |
| `firebase_project_id` | Firebase project ID (optional, for logging) | No | `""` |
| `release_notes_file` | Path to release notes file | No | `deploy/release_notes.txt` |
| `release_notes` | Release notes text (alternative to file) | No | `""` |
| `groups` | Comma-separated list of tester groups | No | `testers` |
| `testers` | Comma-separated list of tester emails | No | `""` |
| `service_account_path` | Path to Firebase service account JSON file | No | `firebase_service_account.json` |

## Outputs

| Output | Description |
|--------|-------------|
| `app_id` | The Firebase Android App ID used for deployment |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `FIREBASE_APP_ID_ANDROID` | The Firebase Android App ID (available to subsequent steps) |

## What This Action Does

1. **Caches Gradle Dependencies** (if enabled)
   - Caches Gradle caches, wrapper, and project Gradle files
   - Speeds up subsequent builds

2. **Checks for File Changes** (if `deploy_trigger_paths` is provided)
   - Compares changed files against base branch (PRs) or previous commit (pushes)
   - Determines if deployment should be triggered based on watched paths
   - Skips deployment if no relevant changes detected

3. **Builds Flutter APK**
   - Builds APK with specified target file, flavor, and mode
   - Supports additional build arguments

4. **Extracts Firebase App ID** (if not provided)
   - Reads firebase.json and extracts Android App ID
   - Uses configurable path in JSON structure

5. **Deploys to Firebase App Distribution** (if enabled and conditions met)
   - Uses service account authentication
   - Distributes APK to specified groups and/or testers
   - Includes release notes from file or text

## Requirements

- Flutter must be set up before running this action
- Firebase CLI must be installed
- Firebase service account JSON file must exist
- `firebase.json` must be configured (if not providing app ID directly)
- Android build configuration must be set up

## Notes

- The action automatically uses service account authentication via `GOOGLE_APPLICATION_CREDENTIALS`
- APK path defaults to standard Flutter output location but can be customized
- Release notes can be provided via file or text input
- Both groups and testers can be specified (comma-separated)
- Gradle caching significantly speeds up builds in CI/CD
- App ID is extracted using Python's json module
- **Conditional Deployment**: When `deploy_trigger_paths` is provided, the action uses `git diff` to check for changes:
  - For pull requests: compares against the base branch
  - For pushes: compares against the previous commit (HEAD~1)
  - Deployment only occurs if at least one file in the watched paths has changed
  - This is ideal for multi-flavor setups where you want to deploy each flavor independently

## APK Output Paths

Default APK paths based on flavor:
- No flavor: `build/app/outputs/apk/release/app-release.apk`
- With flavor: `build/app/outputs/apk/{flavor}/release/app-{flavor}-release.apk`

You can override with `apk_output_path` if your build outputs to a different location.
