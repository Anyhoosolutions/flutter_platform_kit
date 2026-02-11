# Reusable Full Deploy Workflow

A reusable GitHub Actions workflow for deploying Flutter applications to multiple platforms and flavors.

## Features

- **Multi-platform**: Deploy Android, iOS, and Web simultaneously
- **Multi-flavor**: Support up to 5 flavors per platform
- **Firebase integration**: App Distribution (Android/iOS) and Hosting (Web)
- **Automatic updates**: Future improvements work automatically
- **Self-contained**: All logic in this repository

## Documentation

| Document | Description |
|----------|-------------|
| [SETUP.md](SETUP.md) | **Prerequisites:** Age-key setup, Firebase service account, IAM roles, and secrets |
| [CONFIG-REFERENCE.md](CONFIG-REFERENCE.md) | Complete `deploy-config.json` field reference |
| [WORKFLOW-REFERENCE.md](WORKFLOW-REFERENCE.md) | Complete workflow input reference |

## Quick Start

### 1. Create the workflow file

Copy `deploy-workflow-template.yml` to `.github/workflows/deploy.yml` in your app repository:

```yaml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version (e.g., 1.0.2+123)'
        required: true
        type: string
      android_flavor1:
        description: 'Android - My App'  # Customize this
        type: boolean
        default: false
      web_flavor1:
        description: 'Web - My App'  # Customize this
        type: boolean
        default: false

jobs:
  deploy:
    uses: Anyhoosolutions/flutter_platform_kit/.github/workflows/reusable-full-deploy.yml@main
    with:
      version: ${{ inputs.version }}
      android_flavor1: ${{ inputs.android_flavor1 }}
      web_flavor1: ${{ inputs.web_flavor1 }}
    secrets: inherit
```

### 2. Create the configuration file

Copy `deploy-config-template.json` to `.github/deploy-config.json`:

```json
{
  "flutter_version": "3.38.4",
  
  "flavor_mapping": {
    "flavor1": "main",
    "flavor2": null,
    "flavor3": null,
    "flavor4": null,
    "flavor5": null
  },
  
  "flavors": {
    "main": {
      "target_file": "lib/main.dart",
      "android": {
        "firebase_app_id": "1:123:android:abc",
        "distribution_groups": ["testers"]
      },
      "web": {
        "deploy_only": "hosting"
      }
    }
  },
  
  "firebase": {
    "project_id": "your-project-id"
  }
}
```

### 3. Set up secrets

In your repository settings, add:

| Secret | Description |
|--------|-------------|
| `SOPS_AGE_KEY` | Age private key for SOPS decryption |

See [SETUP.md](SETUP.md) for detailed setup instructions including:
- **Age-key:** How to generate and configure SOPS/age encryption
- **Firebase service account:** Creating the service account, required IAM roles (App Distribution, Hosting, Functions), and links to official docs

### 4. Deploy

1. Go to Actions → Deploy
2. Click "Run workflow"
3. Enter version and select platforms to deploy
4. Click "Run workflow"

## Common Configurations

### Single app (no flavors)

```json
{
  "flavor_mapping": {
    "flavor1": "main"
  },
  "flavors": {
    "main": {
      "target_file": "lib/main.dart",
      "android": { "firebase_app_id": "..." },
      "web": { "deploy_only": "hosting" }
    }
  }
}
```

### Multiple flavors

```json
{
  "flavor_mapping": {
    "flavor1": "production",
    "flavor2": "staging"
  },
  "flavors": {
    "production": {
      "target_file": "lib/main_prod.dart",
      "android": { "firebase_app_id": "...", "flavor": "production" }
    },
    "staging": {
      "target_file": "lib/main_staging.dart",
      "android": { "firebase_app_id": "...", "flavor": "staging" }
    }
  }
}
```

### With Firebase Functions

Functions are automatically built when included in `deploy_only`:

```json
{
  "flavors": {
    "main": {
      "web": {
        "deploy_only": "hosting,functions"
      }
    }
  },
  "functions": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build"
  }
}
```

### With Widgetbook

Requires multi-site hosting setup:

```bash
# Set up hosting targets (run once)
firebase target:apply hosting app your-project-id
firebase target:apply hosting widgetbook your-project-widgetbook
```

```json
{
  "flavors": {
    "main": {
      "web": {
        "hosting_target": "app",
        "deploy_only": "hosting"
      }
    }
  },
  "widgetbook": {
    "directory": "widgetbook",
    "hosting_target": "widgetbook"
  }
}
```

### With release_info.dart

Automatically updates version info during deployment:

```json
{
  "release_info": {
    "path": "lib/features/about/release_info.dart"
  }
}
```

## Troubleshooting

### "Directory for Hosting does not exist"

**Problem:** Firebase tries to deploy all hosting sites including widgetbook.

**Solution:** Set `hosting_target` in your web config:

```json
{
  "web": {
    "hosting_target": "app",
    "deploy_only": "hosting"
  }
}
```

### Groups shows as "1001"

**Problem:** Bash reserved variable conflict.

**Solution:** This is fixed in the latest version. Update your `flutter_platform_kit` reference.

### Target file not found

**Problem:** The `target_file` path is incorrect.

**Solution:** Verify the path exists in your repo:

```json
{
  "flavors": {
    "main": {
      "target_file": "lib/main.dart"  // Must exist
    }
  }
}
```

### Flutter analyze fails on unrelated directories

**Problem:** Linter checks `widgetbook/` or `scripts/` directories.

**Solution:** Add to your root `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - widgetbook/**
    - scripts/**
```

## Files in This Directory

| File | Description |
|------|-------------|
| `README.md` | This quick start guide |
| `SETUP.md` | Prerequisites: Age-key and Firebase service account setup |
| `CONFIG-REFERENCE.md` | Complete config field reference |
| `WORKFLOW-REFERENCE.md` | Complete workflow input reference |
| `deploy-config-template.json` | Template for `.github/deploy-config.json` |
| `deploy-workflow-template.yml` | Template for `.github/workflows/deploy.yml` |
| `actions/` | Composite actions used by the workflow |
