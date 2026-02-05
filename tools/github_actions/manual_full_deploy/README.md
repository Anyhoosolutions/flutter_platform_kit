# Reusable Full Deploy Workflow

A reusable GitHub Actions workflow for deploying Flutter applications to multiple platforms and flavors. Designed to be called from app repositories with zero code changes required for deployment.

## Features

- **Reusable template**: Lives in `flutter_platform_kit`, called from app repos
- **Multi-platform**: Deploy Android, iOS, and Web simultaneously
- **Multi-flavor**: Support up to 5 flavors per platform
- **Branch/commit selection**: Deploy any branch or specific commit
- **Firebase integration**: Firebase App Distribution (Android/iOS) and Hosting (Web)
- **Automatic updates**: Future improvements (e.g., Play Store support) work automatically

## Quick Start

### 1. Create the wrapper workflow in your app repo

Copy `deploy-workflow-template.yml` to `.github/workflows/deploy.yml` and customize the flavor descriptions:

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version (e.g., 1.0.2+123)'
        required: true
        type: string
      
      # Customize these descriptions!
      android_flavor1:
        description: 'Android - Snap & Savor'  # Your actual app name
        type: boolean
        default: false
      android_flavor2:
        description: 'Android - Admin Panel'   # Your second flavor
        type: boolean
        default: false
      # ... etc

jobs:
  deploy:
    uses: Anyhoosolutions/flutter_platform_kit/.github/workflows/reusable-full-deploy.yml@main
    with:
      version: ${{ inputs.version }}
      android_flavor1: ${{ inputs.android_flavor1 }}
      android_flavor2: ${{ inputs.android_flavor2 }}
      # ... pass through all inputs
    secrets: inherit
```

### 2. Create the configuration file

Copy `deploy-config-template.json` to `.github/deploy-config.json` and configure:

```json
{
  "flutter_version": "3.38.4",
  
  "flavor_mapping": {
    "flavor1": "snapandsavor",
    "flavor2": "admin",
    "flavor3": null,
    "flavor4": null,
    "flavor5": null
  },
  
  "flavors": {
    "snapandsavor": {
      "target_file": "lib/main.dart",
      "android": {
        "firebase_app_id": "1:662631605767:android:5f42abaa1d0bb2b2972ca2",
        "distribution_groups": ["testers"]
      },
      "web": {
        "hosting_target": "app",
        "deploy_only": "hosting,functions"
      }
    },
    "admin": {
      "target_file": "lib/admin/main.dart",
      "android": {
        "firebase_app_id": "1:662631605767:android:admin123",
        "flavor": "admin"
      }
    }
  },
  
  "firebase": {
    "project_id": "snapandsavor-ef356"
  }
}
```

### 3. Set up secrets

In your repository settings, add:
- `SOPS_AGE_KEY`: Your SOPS age key for decrypting secrets

### 4. Run the workflow

1. Go to **Actions** > **Deploy**
2. Click **Run workflow**
3. Select your branch (or enter a commit SHA)
4. Check the deployments you want
5. Enter version and release notes
6. Click **Run workflow**

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Your App Repository                      │
├─────────────────────────────────────────────────────────────┤
│  .github/                                                    │
│    workflows/                                                │
│      deploy.yml        ← Thin wrapper (customize here)      │
│    deploy-config.json  ← Your flavor configs                │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ uses: ...reusable-full-deploy.yml@main
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              flutter_platform_kit Repository                 │
├─────────────────────────────────────────────────────────────┤
│  .github/workflows/                                          │
│    reusable-full-deploy.yml  ← All the logic lives here     │
└─────────────────────────────────────────────────────────────┘
```

## Workflow Inputs

The wrapper workflow passes these inputs to the reusable workflow:

| Input | Type | Description |
|-------|------|-------------|
| `commit_sha` | string | Specific commit to deploy (empty = branch HEAD) |
| `version` | string | Version name (e.g., 1.0.2+123) |
| `release_notes` | string | Release notes text |
| `android_flavor1..5` | boolean | Deploy Android for each flavor slot |
| `ios_flavor1..5` | boolean | Deploy iOS for each flavor slot |
| `web_flavor1..5` | boolean | Deploy Web for each flavor slot |
| `functions` | boolean | Deploy Firebase Functions |
| `widgetbook` | boolean | Deploy Widgetbook |

## Configuration File Reference

### `flavor_mapping`

Maps generic flavor slots to your actual flavor names:

```json
{
  "flavor_mapping": {
    "flavor1": "main",      // When user checks "Flavor 1", use config for "main"
    "flavor2": "admin",     // When user checks "Flavor 2", use config for "admin"
    "flavor3": null,        // Flavor 3 not configured (checkbox ignored)
    "flavor4": null,
    "flavor5": null
  }
}
```

### `flavors.<name>`

Configuration for each flavor:

```json
{
  "flavors": {
    "main": {
      "description": "Main production app",
      "target_file": "lib/main.dart",
      
      "android": {
        "firebase_app_id": "1:xxx:android:xxx",
        "flavor": "",                           // Flutter --flavor argument
        "build_args": "--no-tree-shake-icons",
        "distribution_groups": ["testers"]
      },
      
      "ios": {
        "firebase_app_id": "1:xxx:ios:xxx",
        "flavor": "",
        "build_args": "--no-tree-shake-icons",
        "distribution_groups": ["testers"]
      },
      
      "web": {
        "hosting_target": "app",
        "deploy_only": "hosting,functions,firestore,storage",
        "build_args": "",
        "build_functions": true
      }
    }
  }
}
```

### `firebase`

Firebase project settings:

```json
{
  "firebase": {
    "project_id": "your-project-id",
    "service_account_path": "firebase_service_account.json"
  }
}
```

### `functions`

Firebase Functions settings:

```json
{
  "functions": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build",
    "chmod_biome": true
  }
}
```

### `widgetbook`

Widgetbook settings:

```json
{
  "widgetbook": {
    "directory": "widgetbook",
    "hosting_target": "widgetbook"
  }
}
```

## Deploying a Specific Commit

To deploy a specific commit instead of the branch HEAD:

1. Run the workflow from any branch
2. Enter the full commit SHA in the "Commit SHA" field
3. The workflow will checkout and deploy that exact commit

This is useful for:
- Deploying a known-good commit after a bad merge
- Deploying an older version for testing
- Cherry-picking specific changes for deployment

## Adding a New Flavor

1. **Update `deploy-config.json`** in your app repo:
   - Add the new flavor to `flavor_mapping` (e.g., `"flavor3": "restaurant"`)
   - Add the full configuration under `flavors`

2. **Update `deploy.yml`** in your app repo:
   - Change the description for the corresponding checkbox (e.g., `'Android - Restaurant'`)

No changes needed to flutter_platform_kit!

## Future Enhancements

The reusable workflow is designed for future additions:

- **Google Play Store**: AAB builds and Play Store deployment
- **TestFlight**: iOS TestFlight distribution
- **App Store**: Direct App Store submission
- **Build promotion**: Promote builds between environments

When these features are added to `reusable-full-deploy.yml`, all app repos using it will automatically have access (may require config updates).

## Troubleshooting

### "Flavor not configured" error

The flavor slot you selected doesn't have a mapping in `deploy-config.json`. Check that:
1. `flavor_mapping.flavorN` maps to a valid flavor name
2. That flavor name exists in the `flavors` object

### iOS build fails on CocoaPods

Try updating your `Podfile.lock`:
```bash
cd ios && pod install --repo-update && cd ..
git add ios/Podfile.lock && git commit -m "Update Podfile.lock"
```

### Firebase permission denied

Ensure your service account has these roles:
- Firebase Admin SDK Administrator Service Agent
- Service Usage Consumer
- Cloud Functions Admin (if deploying functions)

## Files Reference

| File | Location | Purpose |
|------|----------|---------|
| `reusable-full-deploy.yml` | flutter_platform_kit | The reusable workflow (don't modify) |
| `deploy-workflow-template.yml` | flutter_platform_kit | Template for app repos |
| `deploy-config-template.json` | flutter_platform_kit | Template config file |
| `deploy.yml` | Your app repo | Your customized wrapper |
| `deploy-config.json` | Your app repo | Your flavor configurations |
