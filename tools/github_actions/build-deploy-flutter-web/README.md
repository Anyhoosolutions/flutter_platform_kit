# Build and Deploy Flutter Web Composite Action

A reusable GitHub Actions composite action for building Flutter web applications and deploying them to Firebase Hosting.

## Location

This action is located in `tools/github_actions/build-deploy-flutter-web/` to make it easy to share across repositories.

## Features

- ✅ Builds Flutter web applications with configurable target files
- ✅ Supports Widgetbook builds (with build_runner)
- ✅ Deploys to Firebase Hosting with configurable targets
- ✅ Conditional deployment based on changed files (perfect for multiple apps)
- ✅ Skip build and deployment using PR labels (e.g., `no-deploy:app`)
- ✅ Supports custom output directories
- ✅ Configurable build modes and arguments
- ✅ Supports deploying multiple Firebase services

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/main.dart"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "app"
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

- name: Build and deploy Flutter web
  uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/main.dart"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "app"
```

### Widgetbook Build

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    is_widgetbook: "true"
    widgetbook_dir: "widgetbook"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "widgetbook"
```

### Multiple Apps with Custom Output Directories

```yaml
# Build and deploy main app
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/shucked/main/main.dart"
    copy_to_output: "true"
    output_dir: "web_app"
    firebase_project_id: "my-project-id"
    firebase_deploy_only: "hosting:app,functions,firestore,storage"
    firebase_deploy_args: "--non-interactive"

# Build and deploy restaurant app
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/restaurant/restaurant_main.dart"
    copy_to_output: "true"
    output_dir: "web_restaurant"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "restaurant"

# Build and deploy admin app
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/admin/admin_main.dart"
    copy_to_output: "true"
    output_dir: "web_admin"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "admin"
```

### Build Only (No Deployment)

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/main.dart"
    deploy: "false"
```

### Conditional Deployment Based on Changed Files

Deploy only when specific files or directories have changed. This is especially useful when you have multiple apps and want to deploy each app only when its relevant files change:

```yaml
# Deploy main app only if main app files changed
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/shucked/main/main.dart"
    copy_to_output: "true"
    output_dir: "web_app"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "app"
    deploy_trigger_paths: |
      lib/shucked/main/
      lib/shared/
      pubspec.yaml

# Deploy restaurant app only if restaurant files changed
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/restaurant/restaurant_main.dart"
    copy_to_output: "true"
    output_dir: "web_restaurant"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "restaurant"
    deploy_trigger_paths: |
      lib/restaurant/
      lib/shared/
      pubspec.yaml

# Deploy admin app only if admin files changed
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/admin/admin_main.dart"
    copy_to_output: "true"
    output_dir: "web_admin"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "admin"
    deploy_trigger_paths: |
      lib/admin/
      lib/shared/
      pubspec.yaml
```

When `deploy_trigger_paths` is provided:
- The action checks if any files matching the specified paths have changed (compared to the base branch for PRs, or previous commit for pushes)
- Deployment only occurs if changes are detected in the watched paths
- If `deploy_trigger_paths` is empty or not provided, deployment behavior is unchanged (controlled by the `deploy` input)

### Skip Build and Deployment Using PR Labels

You can skip the entire action (both build and deployment) by adding specific labels to your pull request. This is useful when you want to merge code without triggering a build or deployment.

**Supported Label Formats:**

1. **Generic skip** (skips all builds and deployments):
   - `no-deploy`
   - `No Deploy`
   - `NO-DEPLOY`
   - Any case variation

2. **Hosting target-specific skip** (skips build and deployment for a specific hosting target):
   - `no-deploy:app` - Skips build and deployment for the `app` hosting target
   - `no-deploy:restaurant` - Skips build and deployment for the `restaurant` hosting target
   - `No Deploy: widgetbook` - Case and spacing variations are supported
   - Format: `no-deploy:<hosting_target>` where `<hosting_target>` matches your `firebase_hosting_target` input

3. **Output directory-specific skip** (if hosting target is not set):
   - `no-deploy:web_app` - Skips build and deployment for the `web_app` output directory
   - `no-deploy:web_restaurant` - Skips build and deployment for the `web_restaurant` output directory
   - Format: `no-deploy:<output_dir>` where `<output_dir>` matches your `output_dir` input
   - Only used when `firebase_hosting_target` is not provided

**How It Works:**

- **For PR events**: Labels are checked directly from the pull request
- **For push events** (after merge): The action extracts the PR number from the commit message and fetches labels via GitHub API
- Label matching is **case-insensitive** and handles variations (spaces, hyphens, etc.)
- When a matching label is found, the **entire action is skipped** (no build, no deployment)
- This saves CI/CD resources and time when you know a build isn't needed

**Examples:**

```yaml
# This will skip the entire action (build + deploy) if PR has "no-deploy:app" label
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/build-deploy-flutter-web@main
  with:
    target_file: "lib/main.dart"
    firebase_project_id: "my-project-id"
    firebase_hosting_target: "app"
```

To skip build and deployment:
1. Add label `no-deploy:app` to your PR (matching your hosting target)
2. Merge the PR
3. The entire action will be skipped (no build, no deployment)

**Use Cases:**

- Merge documentation-only changes without building
- Merge configuration changes that don't require a new build
- Skip build for specific apps while building others
- Temporary skip during maintenance or testing
- Save CI/CD resources when builds aren't needed

## Inputs

### Build Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `target_file` | Target Dart file to build | Yes | - |
| `build_mode` | Build mode (release, debug, profile) | No | `release` |
| `build_args` | Additional arguments for flutter build web | No | `""` |
| `output_dir` | Output directory name (if copy_to_output is true) | No | `""` |
| `copy_to_output` | Whether to copy build/web to a custom output directory | No | `false` |

### Widgetbook Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `is_widgetbook` | Whether this is a Widgetbook build | No | `false` |
| `widgetbook_dir` | Path to widgetbook directory | No | `widgetbook` |
| `build_runner_args` | Additional arguments for build_runner | No | `--delete-conflicting-outputs` |

### Deployment Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `deploy` | Whether to deploy to Firebase Hosting | No | `true` |
| `deploy_trigger_paths` | Newline-separated list of paths/patterns that should trigger deployment. If provided, deployment only occurs if files matching these paths have changed. If empty, deployment happens based on `deploy` input only. | No | `""` |
| `firebase_project_id` | Firebase project ID | Yes | - |
| `firebase_hosting_target` | Firebase hosting target (e.g., app, restaurant) | No | `""` |
| `firebase_deploy_only` | Firebase deploy --only flag (e.g., 'hosting:app,functions') | No | `""` |
| `firebase_deploy_args` | Additional arguments for firebase deploy | No | `""` |
| `service_account_path` | Path to Firebase service account JSON file | No | `firebase_service_account.json` |

## Outputs

This action does not produce outputs, but builds are available in:
- `build/web` - Default build output
- `build/{output_dir}` - Custom output directory (if `copy_to_output: true`)
- `{widgetbook_dir}/build/web` - Widgetbook build output

## What This Action Does

1. **Checks for Skip Labels** (always runs first)
   - For PR events: Checks labels directly from the pull request
   - For push events: Extracts PR number from commit message and fetches labels via GitHub API
   - Skips the entire action (build and deployment) if a matching `no-deploy` or `no-deploy:<target>` label is found
   - Label matching is case-insensitive and handles variations
   - If a skip label is found, all subsequent steps are skipped

2. **Checks for File Changes** (if `deploy_trigger_paths` is provided)
   - Compares changed files against base branch (PRs) or previous commit (pushes)
   - Determines if deployment should be triggered based on watched paths
   - Skips deployment if no relevant changes detected

3. **Builds Flutter Web**
   - For Widgetbook: Runs build_runner, then builds web
   - For regular apps: Builds web with specified target file
   - Optionally copies output to custom directory

4. **Deploys to Firebase Hosting** (if enabled and conditions met)
   - Uses service account authentication
   - Deploys to specified hosting target or uses `--only` flag
   - Supports deploying multiple services (functions, firestore, storage)

## Requirements

- Flutter must be set up before running this action
- Firebase CLI must be installed
- Firebase service account JSON file must exist
- `firebase.json` must be configured with hosting targets

## Notes

- The action automatically uses service account authentication via `GOOGLE_APPLICATION_CREDENTIALS`
- For Widgetbook builds, deployment happens from the widgetbook directory
- Use `firebase_deploy_only` for complex deployments (e.g., multiple services)
- Use `firebase_hosting_target` for simple single-target deployments
- Custom output directories are useful when building multiple apps in the same workflow
- **Conditional Deployment**: When `deploy_trigger_paths` is provided, the action uses `git diff` to check for changes:
  - For pull requests: compares against the base branch
  - For pushes: compares against the previous commit (HEAD~1)
  - Deployment only occurs if at least one file in the watched paths has changed
  - This is ideal for multi-app setups where you want to deploy each app independently
- **Skip Build and Deployment Labels**: You can skip the entire action by adding labels to your PR:
  - Generic `no-deploy` label skips all builds and deployments
  - Hosting target-specific `no-deploy:<hosting_target>` label skips build and deployment for that specific target
  - Output directory-specific `no-deploy:<output_dir>` label skips build and deployment for that specific output directory (when hosting target is not set)
  - Works for both PR events and push events (after merge)
  - When a skip label is found, the entire action is skipped (no build, no deployment)
  - This saves CI/CD resources when builds aren't needed
