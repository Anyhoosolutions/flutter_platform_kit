# Sentry CLI

A command-line tool for querying Sentry issues.

## Setup

### 1. Get a Sentry auth token

Works on all Sentry plans (including free Developer plan).

**Easiest:** Go to [Account → Auth Tokens](https://sentry.io/settings/account/api/auth-tokens/) and create a **User Auth Token** with scopes:
- `project:read`
- `event:read`

**Alternative:** Create an [Internal Integration](https://sentry.io/settings/developer-settings/) under your org for more granular permissions (set Project = Read, Issue & Event = Read).

### 2. Create config file

Create `~/.sentryrc`:

```json
{
  "token": "sntrys_xxx...",
  "org": "anyhoosolutions",
  "default_project": "snap-and-savor",
  "projects": {
    "sns": "snap-and-savor",
    "admin": "admin-dashboard"
  }
}
```

The `projects` map lets you use short aliases with `-p`.

### 3. Install dependencies

```bash
cd tools/sentry_cli
dart pub get
```

## Usage

### List issues

```bash
# Default: unresolved issues, sorted by last seen
dart run bin/sentry_cli.dart list

# Short form (list is the default command)
dart run bin/sentry_cli.dart

# Use a project alias
dart run bin/sentry_cli.dart -p sns

# Output as JSON
dart run bin/sentry_cli.dart --json

# Filter by level
dart run bin/sentry_cli.dart --level error

# Filter by release (supports wildcards)
dart run bin/sentry_cli.dart --release "com.example.app@1.2.*"

# Filter by environment
dart run bin/sentry_cli.dart --env production

# Sort by frequency
dart run bin/sentry_cli.dart --sort freq

# Limit results
dart run bin/sentry_cli.dart --limit 10

# Raw Sentry search query
dart run bin/sentry_cli.dart --query "assigned:me has:assignee"

# Combine filters
dart run bin/sentry_cli.dart --level error --sort freq --limit 10

# Include resolved issues
dart run bin/sentry_cli.dart --all
```

### Show issue details

```bash
# Show issue with stacktrace
dart run bin/sentry_cli.dart show PROJ-123

# Show as JSON
dart run bin/sentry_cli.dart show PROJ-123 --json
```

## Options

| Flag | Short | Description |
|------|-------|-------------|
| `--token` | | Sentry auth token (overrides config/env) |
| `--org` | `-o` | Organization slug |
| `--project` | `-p` | Project slug or alias |
| `--json` | | Output as JSON |
| `--query` | `-q` | Raw Sentry search query |
| `--level` | | Filter: `error`, `warning`, `info`, `fatal`, `debug` |
| `--unresolved` | | Only unresolved issues (default: true) |
| `--all` | | Show all issues including resolved |
| `--release` | | Filter by release (supports wildcards) |
| `--environment` | | Filter by environment |
| `--sort` | `-s` | Sort: `date`, `new`, `freq`, `priority` |
| `--limit` | `-l` | Max results (default: 25) |

## Config resolution

Values are resolved in this order (first wins):

1. CLI flags (`--token`, `--org`, `--project`)
2. Environment variables (`SENTRY_AUTH_TOKEN`, `SENTRY_ORG`, `SENTRY_PROJECT`)
3. `~/.sentryrc` file

## Optional: Create a shell alias

```bash
# Add to ~/.zshrc
alias sentry='dart run /path/to/tools/sentry_cli/bin/sentry_cli.dart'
```

Then use as:

```bash
sentry list --level error
sentry show PROJ-123
```
