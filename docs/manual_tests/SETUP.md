# Setup Guide: Manual Tests Workflow

This guide covers the one-time setup for using the manual tests workflow. Most setup is per repository; organization-level settings are minimal.

> **Source:** `tools/github_actions/manual_tests/SETUP.md`

## Per-Repository Setup

Each repository that uses the manual tests workflow needs:

1. **Add the workflow file:** Copy `manual-tests-workflow-template.yml` to `.github/workflows/manual-tests.yml`
2. **Create the configuration file:** Copy `tests-config-template.json` to `.github/tests-config.json` and customize
3. **Commit and push**

See `tools/github_actions/manual_tests/SETUP.md` in this repository for the full setup guide.

## Organization Setup (One-Time)

- Ensure Actions are enabled (default)
- No extra secrets or permissions required
- No SOPS or Firebase service account needed for tests

## Triggering from PR Comments

Comment on a pull request:

```
/test flutter patrol
```

**Aliases:** `f` (flutter), `p` (patrol), `r` (rules), `func` (functions)

Tests run on the PR head commit.
