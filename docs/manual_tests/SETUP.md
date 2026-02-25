# Setup Guide: Manual Tests Workflow

This guide covers the one-time setup for using the manual tests workflow. Most setup is per repository; organization-level settings are minimal.

---

## Table of Contents

1. [Per-Repository Setup](#per-repository-setup)
2. [Organization Setup (One-Time)](#organization-setup-one-time)
3. [Triggering Tests](#triggering-tests)
4. [Permissions](#permissions)

---

## Per-Repository Setup

Each repository that uses the manual tests workflow needs:

### 1. Add the workflow file

Copy `manual-tests-workflow-template.yml` to `.github/workflows/manual-tests.yml`:

```bash
mkdir -p .github/workflows
cp path/to/flutter_platform_kit/tools/github_actions/manual_tests/manual-tests-workflow-template.yml .github/workflows/manual-tests.yml
```

### 2. Create the configuration file

Copy `tests-config-template.json` to `.github/tests-config.json` and customize for your repo:

```bash
cp path/to/flutter_platform_kit/tools/github_actions/manual_tests/tests-config-template.json .github/tests-config.json
```

Edit `.github/tests-config.json` to match your project structure (packages, test paths, Firebase project ID). See [CONFIG-REFERENCE.md](CONFIG-REFERENCE.md) for all options.

### 3. Commit and push

Commit both files and push. The workflow is now available.

---

## Organization Setup (One-Time)

If your organization restricts GitHub Actions, ensure the following:

### Enable Actions

- **Repository:** Settings → Actions → General → Allow all actions and reusable workflows (or allow actions from your org)
- **Organization:** Settings → Actions → General → Same as above if you use org-wide policies

### Default permissions

The workflow uses `contents: read` and `pull-requests: read`. The default `GITHUB_TOKEN` has these. No extra secrets or permissions are required.

### No secrets required

Unlike the deploy workflow, manual tests do not need SOPS, age keys, or Firebase service accounts. Tests run against emulators with generated placeholder config.

---

## Triggering Tests

### From the Actions UI

1. Go to **Actions** → **Manual Tests**
2. Click **Run workflow**
3. Optionally enter a branch or commit SHA (empty = default branch)
4. Check the test types to run
5. Click **Run workflow**

### From a PR comment

Comment on a pull request with:

```
/test flutter patrol
```

**Format:** `/test` followed by space- or comma-separated test types.

**Test type aliases:**

| Full name | Aliases | Description |
|-----------|---------|-------------|
| Flutter unit tests | `flutter`, `f`, `unit` | Flutter unit tests |
| Patrol / Integration | `patrol`, `p`, `integration` | Patrol or integration tests |
| Firestore rules | `rules`, `r`, `firestore` | Firestore security rules tests |
| Functions | `functions`, `func` | Firebase Functions tests |

**Examples:**

```
/test flutter
/test f, p
/test patrol integration
/test flutter patrol rules functions
/test f p r func
```

Tests run on the **PR head commit** (the latest commit of the branch).

---

## Permissions

**Who can trigger tests?**

- **Manual dispatch:** Anyone with write access to the repository
- **PR comment (`/test`):** Anyone who can comment on the PR (typically anyone with read access; for fork PRs, the PR author and collaborators can comment)

To restrict to collaborators only, use branch protection or repository settings. The workflow does not enforce additional restrictions.
