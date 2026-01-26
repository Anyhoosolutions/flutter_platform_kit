# Prepare Deployment Composite Action

A reusable GitHub Actions composite action that combines version verification, SOPS decryption, environment variable loading, release notes generation, and release_info.dart updates into a single step.

## Location

This action is located in `tools/github_actions/prepare-deployment/` to make it easy to share across repositories.

## Features

- ✅ Verifies version bump and build number increase
- ✅ Installs SOPS and decrypts secrets
- ✅ Loads environment variables from `.env` file
- ✅ Generates release notes from git commits
- ✅ Updates `release_info.dart` with build information
- ✅ All steps are configurable and can be enabled/disabled individually

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/prepare-deployment@main
  with:
    sops_age_key: ${{ secrets.SOPS_AGE_KEY }}
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Basic Usage

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0

- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/prepare-deployment@main
  with:
    app_name: "My App"
    verify_files: "lib/firebase_options.dart,firebase_service_account.json"
    sops_age_key: ${{ secrets.SOPS_AGE_KEY }}
```

### Disable Individual Steps

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/prepare-deployment@main
  with:
    verify_version: "false"  # Skip version verification
    decrypt_secrets: "true"
    load_env: "true"
    generate_release_notes: "true"
    sops_age_key: ${{ secrets.SOPS_AGE_KEY }}
```

## Inputs

### Version Verification

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `verify_version` | Whether to verify version bump | No | `true` |
| `version_file` | Path to the version file | No | `pubspec.yaml` |
| `version_pattern` | Pattern to extract version | No | `version:` |
| `require_build_number_increase` | Whether to require build number to increase | No | `true` |
| `fail_if_no_previous_version` | Whether to fail if no previous version found | No | `true` |

### SOPS Decryption

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `decrypt_secrets` | Whether to decrypt SOPS secrets | No | `true` |
| `sops_version` | SOPS version to install | No | `v3.7.3` |
| `decrypt_script_url` | URL to decrypt-secrets.sh script | No | `https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh` |
| `sops_age_key` | SOPS AGE key for decrypting secrets | No | `""` |
| `verify_files` | Comma-separated list of files to verify | No | `""` |

### Environment Loading

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `load_env` | Whether to load environment variables | No | `true` |
| `env_file` | Path to the .env file | No | `.env` |
| `env_fail_if_missing` | Whether to fail if .env file is not found | No | `true` |

### Release Notes

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `generate_release_notes` | Whether to generate release notes | No | `true` |
| `release_notes_output` | Path to output file for release notes | No | `deploy/release_notes.txt` |
| `app_name` | Application name for release notes header | No | `""` |
| `commit_count` | Number of commits to include | No | `10` |

### Release Info Updates

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `update_release_info` | Whether to update release_info.dart | No | `true` |
| `release_info_path` | Path to release_info.dart file | No | `lib/features/about/release_info.dart` |

## Outputs

| Output | Description |
|--------|-------------|
| `current_version` | The current version string |
| `version_changed` | Whether the version changed (`true`/`false`) |
| `release_notes_file` | Path to the generated release notes file |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `CURRENT_VERSION` | The current version string (available to subsequent steps) |

## Required Secrets

| Secret | Description |
|--------|-------------|
| `SOPS_AGE_KEY` | The AGE key for decrypting SOPS-encrypted files (required if `decrypt_secrets: true`). Must be passed as the `sops_age_key` input: `sops_age_key: ${{ secrets.SOPS_AGE_KEY }}` |

## What This Action Does

1. **Verifies Version** (if enabled)
   - Extracts current version from version file
   - Compares against base branch or previous commit
   - Verifies version changed and build number increased

2. **Decrypts Secrets** (if enabled)
   - Installs SOPS
   - Decrypts files using the flutter_platform_kit script
   - Verifies decrypted files exist (optional)

3. **Loads Environment** (if enabled)
   - Parses `.env` file
   - Loads variables into GitHub Environment

4. **Generates Release Notes** (if enabled)
   - Creates release notes from git commits
   - Includes version, build number, branch, commit hash

5. **Updates release_info.dart** (if enabled)
   - Updates version, build date, commit hash, branch in Dart file
   - Uses version from `CURRENT_VERSION` environment variable

## Requirements

- Git history must be available (use `fetch-depth: 0` in checkout) for version verification
- Repository must have `.sops.yaml` and `scripts/secrets-config.txt` for SOPS decryption
- `.env` file must exist (or set `env_fail_if_missing: false`)

## Notes

- All steps run in sequence and can be individually enabled/disabled
- Version is automatically passed to release notes generation
- Environment variables from `.env` are available to all subsequent steps
- The action provides clear error messages for each step
