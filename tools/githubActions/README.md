# GitHub Actions

This directory contains reusable GitHub Actions composite actions that can be used across multiple repositories.

## Available Actions

### [upload-docs](./upload-docs/)
Uploads documentation to a documentation service. Handles Dart SDK setup, package caching, and PR comments.

**Usage:**
```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/upload-docs@main
  with:
    upload_url: ${{ vars.UPLOAD_URL }}
```

### [check-version](./check-version/)
Checks if a version has been updated in a pull request compared to the base branch. Supports multiple version file formats.

**Usage:**
```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/check-version@main
```

### [firebase-functions-quality](./firebase-functions-quality/)
Runs linting and tests for Firebase Functions. Supports configurable linters and test commands.

**Usage:**
```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-quality@main
```

### [firebase-functions-test](./firebase-functions-test/)
Runs tests for Firebase Functions using Firebase Emulators. Handles Node.js, Java setup, and emulator configuration.

**Usage:**
```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/firebase-functions-test@main
  with:
    firebase_project_id: "your-project-id"
```

## Structure

Each action is in its own subdirectory with:
- `action.yml` - The action definition
- `README.md` - Documentation and usage examples
- `example-workflow.yml` - Example workflow file (if applicable)

## Using Actions

### Recommended: Reference Directly

Reference actions directly from the repository without copying files:

```yaml
- uses: Anyhoosolutions/flutter_platform_kit/tools/githubActions/{action-name}@main
```

You can pin to specific versions:
- `@main` - Latest from main branch
- `@v1.0.0` - Specific tag/version
- `@abc1234` - Specific commit SHA

### Alternative: Copy to Repository

If you need to customize an action, copy it to your repository:

```bash
mkdir -p .github/actions
cp -r path/to/flutter_platform_kit/tools/githubActions/{action-name} .github/actions/{action-name}
```

Then reference it locally:
```yaml
- uses: ./.github/actions/{action-name}
```

## Adding New Actions

When adding a new action:

1. Create a new subdirectory in `tools/githubActions/`
2. Add `action.yml` with the action definition
3. Add `README.md` with documentation
4. Add `example-workflow.yml` if helpful
5. Update this README to list the new action

## Notes

- All actions in this directory are meant to be reusable across repositories
- Repository-specific actions should go in `.github/actions/` instead
- Actions can reference each other using relative paths if needed
