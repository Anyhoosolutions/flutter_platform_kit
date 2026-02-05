# Upload Documentation Composite Action

A simple, reusable GitHub Actions composite action for uploading documentation to a documentation service.

## Location

This action is located in `tools/github_actions/upload-docs/` to make it easy to share across repositories.

## Features

- ✅ Sets up Dart SDK
- ✅ Caches Dart packages
- ✅ Runs documentation upload
- ✅ Posts PR comment with documentation link (if on PR branch)

## Installation in Other Repositories

To use this action in another repository:

1. Copy the `tools/github_actions/upload-docs/` directory to your repository:
   ```bash
   # From your repository root
   mkdir -p .github/actions
   cp -r path/to/flutter_platform_kit/tools/github_actions/upload-docs .github/actions/upload-docs
   ```

## Usage

### Recommended: Reference Directly from Repository

You can reference this action directly from the repository without copying any files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/upload-docs@main
  with:
    upload_url: ${{ vars.UPLOAD_URL }}
    dart_sdk: '3.5'
```

You can also pin to a specific version, branch, or commit:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Full Example

```yaml
name: Upload Documentation

on:
  push:
    branches: [main]
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  upload:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      
      # Your pre-processing steps here (generate TOC, copy files, etc.)
      
      - uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/upload-docs@main
        with:
          upload_url: ${{ vars.UPLOAD_URL }}
          dart_sdk: '3.5'
          project_root: ${{ github.workspace }}
          commit_hash: ${{ github.sha }}  # For branch-based deployments
          pr_docs_base_url: 'https://example.com/documentation'  # For PR comments
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `upload_url` | The URL endpoint for uploading documentation | Yes | - |
| `dart_sdk` | Dart SDK version to use | No | `3.5` |
| `project_root` | Root directory of the project | No | `${{ github.workspace }}` |
| `commit_hash` | Optional commit hash for branch-based deployments | No | `''` |
| `pr_docs_base_url` | Base URL for PR documentation links | No | `''` |

## What This Action Does

1. **Sets up Dart SDK** - Installs the specified Dart SDK version
2. **Caches Dart packages** - Caches pub packages for faster subsequent runs
3. **Runs documentation upload** - Executes the upload tool with the provided parameters
4. **Posts PR comment** - If on a PR branch and `pr_docs_base_url` is provided, posts a comment with the documentation link

## Branch-based Deployments

For PRs or branch-based deployments, provide a `commit_hash`:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/github_actions/upload-docs@main
  with:
    upload_url: ${{ vars.UPLOAD_URL }}
    commit_hash: ${{ github.sha }}
    pr_docs_base_url: 'https://example.com/documentation'
```

When `commit_hash` is provided, the upload tool will:
- Treat it as a branch deployment
- Add a commit hash suffix to the project name
- Use the commit hash as the project ID

## Pre-processing

This action does **not** handle pre-processing steps like:
- Generating TOC files
- Copying CHANGELOGs, READMEs, or docs directories
- Any repository-specific file operations

These should be handled in your workflow file before calling this action.

## Requirements

- The `upload_documentation` tool must be available at the specified path
- The `docs/` directory must exist and be ready for upload
- `UPLOAD_URL` must be set (passed as `upload_url` input)
- For PR comments: `pull-requests: write` permission is required

## Notes

- The action automatically sets up Dart SDK and caches packages
- The action uses `dart pub get --no-precompile` for faster package resolution
- PR comments are only posted if `commit_hash` and `pr_docs_base_url` are provided and the event is a pull request
