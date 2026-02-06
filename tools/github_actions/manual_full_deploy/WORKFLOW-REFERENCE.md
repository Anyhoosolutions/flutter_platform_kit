# Workflow Reference

Complete reference for the deploy workflow inputs.

> **Quick Start:** Copy `deploy-workflow-template.yml` to `.github/workflows/deploy.yml` in your app repository.

## Table of Contents

- [Overview](#overview)
- [Workflow Inputs](#workflow-inputs)
  - [Checkout Options](#checkout-options)
  - [Build Configuration](#build-configuration)
  - [Android Deployments](#android-deployments)
  - [iOS Deployments](#ios-deployments)
  - [Web Deployments](#web-deployments)
  - [Other Deployments](#other-deployments)
- [Required Secrets](#required-secrets)
- [Customization Guide](#customization-guide)

---

## Overview

The deploy workflow is a wrapper that calls the reusable workflow from `flutter_platform_kit`. You customize the workflow file to match your flavor names and descriptions.

**Workflow structure:**

```yaml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      # Your customized inputs here
      
jobs:
  deploy:
    uses: Anyhoosolutions/flutter_platform_kit/.github/workflows/reusable-full-deploy.yml@main
    with:
      # Pass through all inputs
    secrets: inherit
```

---

## Workflow Inputs

All inputs are provided via GitHub's `workflow_dispatch` UI when manually triggering the workflow.

### Checkout Options

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `commit_sha` | string | No | `""` | Specific commit SHA to deploy. Leave empty to use branch HEAD. |

**Usage:**
- Leave empty to deploy the latest commit from the selected branch
- Enter a full commit SHA (e.g., `abc123def456...`) to deploy a specific commit
- Useful for rollbacks or deploying a known-good commit

---

### Build Configuration

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `version` | string | **Yes** | `"0.0.0+XXX"` | Version string for the build (e.g., `1.0.2+123`) |
| `release_notes` | string | No | `"Manual build from GitHub Actions"` | Release notes for Firebase App Distribution |

**Version format:**
- Follows semantic versioning: `MAJOR.MINOR.PATCH+BUILD`
- Example: `1.2.3+456`
- The version is used in:
  - Flutter build (`--build-name` and `--build-number`)
  - `release_info.dart` (if configured)
  - Firebase App Distribution release

---

### Android Deployments

Each Android flavor has a boolean checkbox input. When checked, that flavor will be built and deployed to Firebase App Distribution.

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `android_flavor1` | boolean | `false` | Deploy Android for flavor slot 1 |
| `android_flavor2` | boolean | `false` | Deploy Android for flavor slot 2 |
| `android_flavor3` | boolean | `false` | Deploy Android for flavor slot 3 |
| `android_flavor4` | boolean | `false` | Deploy Android for flavor slot 4 |
| `android_flavor5` | boolean | `false` | Deploy Android for flavor slot 5 |

**Customizing descriptions:**

In your workflow file, customize the `description` field to show meaningful names:

```yaml
android_flavor1:
  description: "Android - Snap & Savor"  # <-- Your app name
  type: boolean
  default: false
android_flavor2:
  description: "Android - Admin Dashboard"  # <-- Your second flavor
  type: boolean
  default: false
```

**Mapping to config:**

The flavor slot maps to your config via `flavor_mapping`:
- `android_flavor1` → looks up `flavor_mapping.flavor1` → gets actual flavor name → uses that flavor's `android` config

---

### iOS Deployments

Each iOS flavor has a boolean checkbox input. When checked, that flavor will be built and deployed to Firebase App Distribution.

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `ios_flavor1` | boolean | `false` | Deploy iOS for flavor slot 1 |
| `ios_flavor2` | boolean | `false` | Deploy iOS for flavor slot 2 |
| `ios_flavor3` | boolean | `false` | Deploy iOS for flavor slot 3 |
| `ios_flavor4` | boolean | `false` | Deploy iOS for flavor slot 4 |
| `ios_flavor5` | boolean | `false` | Deploy iOS for flavor slot 5 |

**Note:** iOS builds run on `macos-latest` runners which are more expensive than Linux runners.

---

### Web Deployments

Each Web flavor has a boolean checkbox input. When checked, that flavor will be built and deployed to Firebase Hosting.

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `web_flavor1` | boolean | `false` | Deploy Web for flavor slot 1 |
| `web_flavor2` | boolean | `false` | Deploy Web for flavor slot 2 |
| `web_flavor3` | boolean | `false` | Deploy Web for flavor slot 3 |
| `web_flavor4` | boolean | `false` | Deploy Web for flavor slot 4 |
| `web_flavor5` | boolean | `false` | Deploy Web for flavor slot 5 |

**Firebase Functions:**

If a web flavor's `deploy_only` includes `"functions"`, Firebase Functions will be automatically built and deployed along with the web content.

---

### Other Deployments

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `widgetbook` | boolean | `false` | Deploy Widgetbook to Firebase Hosting |

**Widgetbook notes:**
- Requires `widgetbook` configuration in `deploy-config.json`
- Requires multi-site hosting setup (see [CONFIG-REFERENCE.md](CONFIG-REFERENCE.md#setting-up-hosting-targets))
- Runs `build_runner` before building

---

## Required Secrets

The workflow uses `secrets: inherit` to pass secrets from your repository to the reusable workflow.

| Secret | Required | Description |
|--------|----------|-------------|
| `SOPS_AGE_KEY` | Yes | Age private key for SOPS decryption |
| `GOOGLE_APPLICATION_CREDENTIALS_BASE64` | Maybe | Base64-encoded service account (alternative to SOPS) |

**Setting up secrets:**
1. Go to your repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add the required secrets

---

## Customization Guide

### Step 1: Copy the template

Copy `deploy-workflow-template.yml` to `.github/workflows/deploy.yml` in your app repository.

### Step 2: Customize flavor descriptions

Update the `description` fields to show your actual flavor names:

```yaml
# Before (generic)
android_flavor1:
  description: "Android - Flavor 1"

# After (customized)
android_flavor1:
  description: "Android - My Awesome App"
```

### Step 3: Remove unused flavors

If you only have 2 flavors, you can remove flavor3-5 inputs:

```yaml
# Remove these blocks entirely
android_flavor3:
  description: "Android - Flavor 3"
  ...
```

Or keep them but set clear descriptions:

```yaml
android_flavor3:
  description: "Android - (Not configured)"
  ...
```

### Step 4: Remove unused platforms

If you don't deploy to iOS, remove all `ios_flavor*` inputs:

```yaml
# Remove this entire section
ios_flavor1:
  description: "iOS - Main App"
  ...
```

And remove from the `with:` section:

```yaml
with:
  # Remove these lines
  ios_flavor1: ${{ inputs.ios_flavor1 }}
  ...
```

---

## Complete Example

Minimal workflow with 2 flavors, Android + Web only:

```yaml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      commit_sha:
        description: "Commit SHA (leave empty for branch HEAD)"
        required: false
        type: string
      version:
        description: "Version (e.g., 1.0.2+123)"
        required: true
        type: string
        default: "0.0.0+XXX"
      release_notes:
        description: "Release Notes"
        required: false
        type: string
        default: "Manual build from GitHub Actions"
      
      android_main:
        description: "Android - Main App"
        type: boolean
        default: false
      android_admin:
        description: "Android - Admin Dashboard"
        type: boolean
        default: false
      
      web_main:
        description: "Web - Main App"
        type: boolean
        default: false
      web_admin:
        description: "Web - Admin Dashboard"
        type: boolean
        default: false
      
      widgetbook:
        description: "Widgetbook"
        type: boolean
        default: false

jobs:
  deploy:
    uses: Anyhoosolutions/flutter_platform_kit/.github/workflows/reusable-full-deploy.yml@main
    with:
      commit_sha: ${{ inputs.commit_sha }}
      version: ${{ inputs.version }}
      release_notes: ${{ inputs.release_notes }}
      android_flavor1: ${{ inputs.android_main }}
      android_flavor2: ${{ inputs.android_admin }}
      web_flavor1: ${{ inputs.web_main }}
      web_flavor2: ${{ inputs.web_admin }}
      widgetbook: ${{ inputs.widgetbook }}
    secrets: inherit
```

**Note:** The input names in your workflow (e.g., `android_main`) can be anything, but you must map them correctly in the `with:` section to the reusable workflow's expected inputs (e.g., `android_flavor1`).
