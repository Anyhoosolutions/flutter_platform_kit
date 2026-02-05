# Manual Full Deploy Workflow

A comprehensive GitHub Actions workflow for deploying Flutter applications to multiple platforms and flavors in a single run.

## Features

- **Multi-platform support**: Deploy to Android, iOS, and Web simultaneously
- **Flavor support**: Deploy multiple flavors (e.g., main app, admin) in parallel
- **Shared preparation**: Common steps run once, saving time and resources
- **Firebase integration**: Deploy to Firebase App Distribution (Android/iOS) and Firebase Hosting (Web)
- **Functions deployment**: Optionally deploy Firebase Functions
- **Widgetbook deployment**: Optionally deploy Widgetbook for component documentation
- **Deployment summary**: Get a clear overview of all deployment results

## Quick Start

### 1. Copy the workflow to your repository

Copy `.github/workflows/manual_full_deploy.yml` to your app repository.

### 2. Create your configuration file

Copy `.github/deploy-config-template.json` to `.github/deploy-config.json` in your app repository and customize it:

```json
{
  "app_name": "Your App Name",
  "flutter_version": "3.38.4",
  "flavors": {
    "main": {
      "target_file": "lib/main.dart",
      "android": {
        "firebase_app_id": "1:123456789:android:abcdef",
        "distribution_groups": ["testers"]
      },
      "ios": {
        "firebase_app_id": "1:123456789:ios:abcdef",
        "distribution_groups": ["testers"]
      },
      "web": {
        "hosting_target": "app",
        "deploy_only": "hosting,functions"
      }
    }
  },
  "firebase": {
    "project_id": "your-project-id"
  }
}
```

### 3. Set up secrets and variables

In your repository settings, add:

**Secrets:**
- `SOPS_AGE_KEY`: Your SOPS age key for decrypting secrets

**Variables:**
- `FIREBASE_PROJECT_ID`: Your Firebase project ID

### 4. Run the workflow

Go to **Actions** > **Manual Full Deploy** > **Run workflow** and select the deployments you want.

## Workflow Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `deploy_android_main` | Deploy Android - Main App | `false` |
| `deploy_android_admin` | Deploy Android - Admin | `false` |
| `deploy_ios_main` | Deploy iOS - Main App | `false` |
| `deploy_ios_admin` | Deploy iOS - Admin | `false` |
| `deploy_web_main` | Deploy Web - Main App | `false` |
| `deploy_web_admin` | Deploy Web - Admin | `false` |
| `deploy_functions` | Deploy Firebase Functions | `false` |
| `deploy_widgetbook` | Deploy Widgetbook | `false` |
| `version` | Version name (e.g., 1.0.2+123) | `0.0.0+XXX` |
| `release_notes` | Release notes for the deployment | `Manual build...` |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Workflow Dispatch                        │
│  ☑ Android Main  ☐ Android Admin  ☑ Web Main  ☐ Functions  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Prepare Job                             │
│  • Checkout code                                             │
│  • Validate inputs                                           │
│  • Compute flavor matrices                                   │
│  • Check SOPS key                                            │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ Android Job   │   │   iOS Job     │   │   Web Job     │
│ (ubuntu)      │   │   (macos)     │   │  (ubuntu)     │
│               │   │               │   │               │
│ matrix:       │   │ matrix:       │   │ matrix:       │
│  - main       │   │  - main       │   │  - main       │
│  - admin      │   │  - admin      │   │  - admin      │
└───────────────┘   └───────────────┘   └───────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Summary Job                             │
│  • Generate deployment report                                │
│  • Show success/failure for each deployment                 │
└─────────────────────────────────────────────────────────────┘
```

## Configuration File Schema

The `deploy-config.json` file supports the following structure:

### Root Level

| Field | Type | Description |
|-------|------|-------------|
| `app_name` | string | Display name of your application |
| `flutter_version` | string | Flutter version to use |
| `flutter_channel` | string | Flutter channel (stable, beta, dev) |
| `flavors` | object | Flavor configurations |
| `firebase` | object | Firebase project settings |
| `functions` | object | Firebase Functions settings |
| `widgetbook` | object | Widgetbook settings |
| `sops` | object | SOPS decryption settings |

### Flavor Configuration

Each flavor supports:

```json
{
  "flavors": {
    "flavor_name": {
      "description": "Human-readable description",
      "target_file": "lib/main.dart",
      "android": {
        "firebase_app_id": "Firebase Android App ID",
        "apk_output_path": "Path to built APK",
        "build_args": "Additional flutter build arguments",
        "distribution_groups": ["group1", "group2"]
      },
      "ios": {
        "firebase_app_id": "Firebase iOS App ID",
        "bundle_id": "com.example.app",
        "distribution_groups": ["group1", "group2"]
      },
      "web": {
        "hosting_target": "Firebase Hosting target name",
        "deploy_only": "hosting,functions,firestore,storage",
        "build_args": "Additional flutter build web arguments"
      }
    }
  }
}
```

## Adding New Flavors

To add a new flavor:

1. Add the flavor configuration to `deploy-config.json`
2. Add new workflow inputs in `manual_full_deploy.yml`:

```yaml
deploy_android_newflavor:
  description: 'Deploy Android - New Flavor'
  required: false
  default: false
  type: boolean
```

3. Update the `compute-flavors` step to include the new flavor:

```bash
if [ "${{ github.event.inputs.deploy_android_newflavor }}" = "true" ]; then
  # ... add to ANDROID_FLAVORS
fi
```

4. Add the flavor case in `Load flavor configuration` steps

## Job Dependencies

| Job | Depends On | Condition |
|-----|------------|-----------|
| `prepare` | - | Always runs |
| `build-deploy-android` | prepare | Any Android checkbox selected |
| `build-deploy-ios` | prepare | Any iOS checkbox selected |
| `build-deploy-web` | prepare | Any Web checkbox selected |
| `deploy-functions` | prepare | Functions checkbox selected |
| `deploy-widgetbook` | prepare | Widgetbook checkbox selected |
| `summary` | All jobs | Always runs (reports results) |

## Troubleshooting

### SOPS decryption fails

Ensure `SOPS_AGE_KEY` secret is set correctly in your repository settings.

### Firebase deployment fails with permission error

1. Verify `FIREBASE_PROJECT_ID` variable is correct
2. Check that `firebase_service_account.json` is properly encrypted and decrypted
3. Ensure the service account has necessary IAM roles:
   - Firebase Admin
   - Service Account Admin
   - Service Usage Admin

### iOS build fails

1. macOS runners have limited resources; ensure your project builds locally
2. CocoaPods installation may fail if Podfile.lock is out of date
3. Unsigned builds are used for Firebase App Distribution

### Matrix job shows empty

If a platform job doesn't run, check:
1. The corresponding checkbox was selected
2. The `compute-flavors` step correctly includes the flavor in the array

## Future Enhancements

This workflow is designed to support future additions:

- **Google Play Store**: AAB builds for production release
- **TestFlight**: iOS TestFlight deployment
- **App Store**: Direct App Store submission
- **Promotion workflows**: Promote builds between environments

## Related Actions

This workflow uses these composite actions from flutter_platform_kit:

- [`prepare-deployment`](../prepare-deployment/README.md)
- [`build-deploy-flutter-apk`](../build-deploy-flutter-apk/README.md)
- [`build-deploy-flutter-web`](../build-deploy-flutter-web/README.md)
