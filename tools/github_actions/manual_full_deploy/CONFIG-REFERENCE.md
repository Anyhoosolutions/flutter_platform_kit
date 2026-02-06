# Configuration Reference

Complete reference for `deploy-config.json` fields.

> **Quick Start:** Copy `deploy-config-template.json` to `.github/deploy-config.json` in your app repository.

## Table of Contents

- [Global Settings](#global-settings)
- [Flavor Mapping](#flavor_mapping)
- [Flavor Configuration](#flavors)
  - [Android Platform](#android-platform)
  - [iOS Platform](#ios-platform)
  - [Web Platform](#web-platform)
- [Firebase Settings](#firebase)
- [Functions Settings](#functions)
- [Widgetbook Settings](#widgetbook)
- [SOPS Settings](#sops)
- [Release Info Settings](#release_info)

---

## Global Settings

Top-level settings that apply to all deployments.

```json
{
  "flutter_version": "3.38.4",
  "flutter_channel": "stable"
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `flutter_version` | string | No | `"3.38.4"` | Flutter SDK version to use |
| `flutter_channel` | string | No | `"stable"` | Flutter channel (`stable`, `beta`, `dev`) |

---

## `flavor_mapping`

Maps generic flavor slots (flavor1-5) to your actual flavor names. This allows the workflow UI to use generic labels while your config uses meaningful names.

```json
{
  "flavor_mapping": {
    "flavor1": "main",
    "flavor2": "admin",
    "flavor3": null,
    "flavor4": null,
    "flavor5": null
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `flavor1` | string \| null | Yes | Flavor name for slot 1, or `null` if unused |
| `flavor2` | string \| null | Yes | Flavor name for slot 2, or `null` if unused |
| `flavor3` | string \| null | Yes | Flavor name for slot 3, or `null` if unused |
| `flavor4` | string \| null | Yes | Flavor name for slot 4, or `null` if unused |
| `flavor5` | string \| null | Yes | Flavor name for slot 5, or `null` if unused |

**Example mapping:**
- User checks "Android - Flavor 1" → workflow looks up `flavor_mapping.flavor1` → gets `"main"` → uses `flavors.main.android` config

---

## `flavors`

Configuration for each flavor. Each flavor can have settings for Android, iOS, and/or Web platforms.

```json
{
  "flavors": {
    "main": {
      "description": "Main production app",
      "target_file": "lib/main.dart",
      "android": { ... },
      "ios": { ... },
      "web": { ... }
    }
  }
}
```

### Flavor Root Fields

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `description` | string | No | - | Human-readable description (for documentation) |
| `target_file` | string | No | `"lib/main.dart"` | Dart entry point file for this flavor |

---

### Android Platform

Configuration for Android builds and Firebase App Distribution.

```json
{
  "android": {
    "firebase_app_id": "1:123456789:android:abcdef123456",
    "flavor": "",
    "build_args": "--no-tree-shake-icons",
    "distribution_groups": ["testers"]
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `firebase_app_id` | string | **Yes** | - | Firebase App ID (from Firebase Console → Project Settings → Your apps) |
| `flavor` | string | No | `""` | Flutter `--flavor` argument (empty if no flavors) |
| `build_args` | string | No | `""` | Additional arguments passed to `flutter build apk` |
| `distribution_groups` | array | No | `["testers"]` | Firebase App Distribution groups to distribute to |

**Finding your Firebase App ID:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project → Project Settings (gear icon)
3. Scroll to "Your apps" → find your Android app
4. Copy the "App ID" (format: `1:123456789:android:abcdef123456`)

---

### iOS Platform

Configuration for iOS builds and Firebase App Distribution.

```json
{
  "ios": {
    "firebase_app_id": "1:123456789:ios:abcdef123456",
    "flavor": "",
    "build_args": "--no-tree-shake-icons",
    "distribution_groups": ["testers"]
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `firebase_app_id` | string | **Yes** | - | Firebase App ID for iOS app |
| `flavor` | string | No | `""` | Flutter `--flavor` argument (empty if no flavors) |
| `build_args` | string | No | `""` | Additional arguments passed to `flutter build ios` |
| `distribution_groups` | array | No | `["testers"]` | Firebase App Distribution groups to distribute to |

---

### Web Platform

Configuration for Web builds and Firebase Hosting.

```json
{
  "web": {
    "hosting_target": "app",
    "deploy_only": "hosting,functions,firestore,storage",
    "build_args": ""
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `hosting_target` | string | No* | `""` | Firebase Hosting target name (see below) |
| `deploy_only` | string | No | `"hosting"` | Comma-separated Firebase services to deploy |
| `build_args` | string | No | `""` | Additional arguments passed to `flutter build web` |

**\* `hosting_target` notes:**
- **Single hosting site:** Leave empty - uses default `firebase.json` configuration
- **Multiple hosting sites:** Set to your target name (must match `firebase.json` and `.firebaserc`)

**`deploy_only` options:**
- `hosting` - Deploy web files to Firebase Hosting
- `functions` - Deploy Firebase Functions (will build first if configured)
- `firestore` - Deploy Firestore rules and indexes
- `storage` - Deploy Storage rules

**Examples:**
```json
// Simple web-only deployment
"deploy_only": "hosting"

// Web + functions
"deploy_only": "hosting,functions"

// Full deployment
"deploy_only": "hosting,functions,firestore,storage"
```

---

## `firebase`

Firebase project settings.

```json
{
  "firebase": {
    "project_id": "your-firebase-project-id",
    "service_account_path": "firebase_service_account.json"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `project_id` | string | **Yes** | - | Your Firebase project ID |
| `service_account_path` | string | No | `"firebase_service_account.json"` | Path to service account JSON file (relative to repo root) |

**Finding your project ID:**
- Firebase Console URL: `https://console.firebase.google.com/project/YOUR-PROJECT-ID/...`
- Or: Project Settings → General → Project ID

---

## `functions`

Firebase Functions build settings. Functions are automatically built when `"functions"` is included in a web flavor's `deploy_only` field.

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

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `path` | string | No | `"functions"` | Path to functions directory (relative to repo root) |
| `install_command` | string | No | `"npm install"` | Command to install dependencies |
| `build_command` | string | No | `"npm run build"` | Command to build/compile functions |
| `chmod_biome` | boolean | No | `false` | Run `chmod +x` on biome binary (fixes permission issues) |

**Examples for different setups:**

```json
// TypeScript functions (default)
{
  "functions": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build"
  }
}

// JavaScript functions (no build needed)
{
  "functions": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "echo 'No build needed'"
  }
}

// Python functions
{
  "functions": {
    "path": "functions",
    "install_command": "pip install -r requirements.txt",
    "build_command": "echo 'No build needed'"
  }
}
```

---

## `widgetbook`

Widgetbook deployment settings.

```json
{
  "widgetbook": {
    "directory": "widgetbook",
    "hosting_target": "widgetbook"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `directory` | string | **Yes** | - | Path to Widgetbook project (relative to repo root) |
| `hosting_target` | string | **Yes** | - | Firebase Hosting target for Widgetbook |

**Note:** Widgetbook deployment requires multi-site hosting setup. See [Setting up hosting targets](#setting-up-hosting-targets).

---

## `sops`

SOPS secrets decryption settings.

```json
{
  "sops": {
    "decrypt_script_url": "https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh",
    "verify_files": [
      "lib/firebase_options.dart",
      "firebase_service_account.json"
    ]
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `decrypt_script_url` | string | No | (platform_kit URL) | URL to SOPS decrypt script |
| `verify_files` | array | No | `[]` | Files to verify exist after decryption |

---

## `release_info`

Settings for automatic `release_info.dart` updates during deployment.

```json
{
  "release_info": {
    "path": "lib/features/about/release_info.dart"
  }
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `path` | string | No | `""` | Path to `release_info.dart` file (empty = skip updates) |

**Expected file format:**

The workflow updates fields matching these patterns:

```dart
class ReleaseInfo {
  final String version = 'dev';
  final String buildDate = '';
  final String commitHash = '';
  final String commitHashShort = '';
  final String branch = '';
}
```

Or constructor format:

```dart
class ReleaseInfo {
  ReleaseInfo({
    this.version = 'dev',
    this.buildDate = '',
    this.commitHash = '',
    this.commitHashShort = '',
    this.branch = '',
  });
}
```

---

## Setting Up Hosting Targets

When using multiple hosting sites (e.g., app + widgetbook), you need to configure Firebase hosting targets.

**1. Apply targets (run once per project):**

```bash
# Map target name "app" to your main hosting site
firebase target:apply hosting app your-project-id

# Map target name "widgetbook" to your widgetbook hosting site
firebase target:apply hosting widgetbook your-project-widgetbook
```

**2. Update firebase.json:**

```json
{
  "hosting": [
    {
      "target": "app",
      "public": "build/web",
      "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
    },
    {
      "target": "widgetbook",
      "public": "widgetbook/build/web",
      "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
    }
  ]
}
```

**3. Verify .firebaserc was updated:**

```json
{
  "projects": {
    "default": "your-project-id"
  },
  "targets": {
    "your-project-id": {
      "hosting": {
        "app": ["your-project-id"],
        "widgetbook": ["your-project-widgetbook"]
      }
    }
  }
}
```

---

## Complete Example

```json
{
  "flutter_version": "3.38.4",
  "flutter_channel": "stable",

  "flavor_mapping": {
    "flavor1": "main",
    "flavor2": "admin",
    "flavor3": null,
    "flavor4": null,
    "flavor5": null
  },

  "flavors": {
    "main": {
      "description": "Main production app",
      "target_file": "lib/main.dart",
      "android": {
        "firebase_app_id": "1:123456789:android:abc123",
        "flavor": "",
        "build_args": "",
        "distribution_groups": ["testers"]
      },
      "ios": {
        "firebase_app_id": "1:123456789:ios:abc123",
        "flavor": "",
        "build_args": "",
        "distribution_groups": ["testers"]
      },
      "web": {
        "hosting_target": "app",
        "deploy_only": "hosting,functions",
        "build_args": ""
      }
    },
    "admin": {
      "description": "Admin dashboard",
      "target_file": "lib/admin/main.dart",
      "android": {
        "firebase_app_id": "1:123456789:android:admin456",
        "flavor": "admin",
        "build_args": "",
        "distribution_groups": ["admin-testers"]
      },
      "web": {
        "hosting_target": "admin",
        "deploy_only": "hosting",
        "build_args": ""
      }
    }
  },

  "firebase": {
    "project_id": "my-project-id",
    "service_account_path": "firebase_service_account.json"
  },

  "functions": {
    "path": "functions",
    "install_command": "npm install",
    "build_command": "npm run build",
    "chmod_biome": true
  },

  "widgetbook": {
    "directory": "widgetbook",
    "hosting_target": "widgetbook"
  },

  "sops": {
    "verify_files": [
      "lib/firebase_options.dart",
      "firebase_service_account.json"
    ]
  },

  "release_info": {
    "path": "lib/features/about/release_info.dart"
  }
}
```
