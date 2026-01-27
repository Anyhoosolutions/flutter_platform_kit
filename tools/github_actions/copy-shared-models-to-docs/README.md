# Copy Shared Models to Docs

A reusable GitHub Actions composite action that runs the `copy_shared_models_to_docs` script from the `freezed_to_ts` tool. It generates a Markdown documentation file containing **Dart** model definitions (no `@freezed`, `part`, `with`, or `fromJson`) from your freezed shared models.

## Location

`tools/github_actions/copy-shared-models-to-docs/`

## Features

- Generates `docs/shared_models.md` (or a custom path) from Dart freezed models
- Output is clean Dart: `class` / `enum` only, suitable for docs
- Skips gracefully if the source path does not exist
- Configurable input/output paths and Dart SDK version

## Usage

### As a step before prepare-docs (recommended)

Run this action before [prepare-docs](https://github.com/lidholm/flutter_platform_kit/tree/main/.github/actions/prepare-docs) so the generated `shared_models.md` is included when you upload documentation:

```yaml
steps:
  - uses: actions/checkout@v4

  - name: Copy shared models to docs
    uses: ./tools/github_actions/copy-shared-models-to-docs
    with:
      source_models_path: "tools/freezed_to_ts/test_data"   # or lib/sharedModels
      output_path: "docs/shared_models.md"

  - name: Prepare documentation
    uses: ./.github/actions/prepare-docs

  - name: Upload documentation
    uses: ./tools/github_actions/upload-docs
    with:
      upload_url: ${{ vars.UPLOAD_URL }}
      # ...
```

### Standalone

```yaml
- uses: actions/checkout@v4

- uses: ./tools/github_actions/copy-shared-models-to-docs
  with:
    source_models_path: "lib/sharedModels"
    output_path: "docs/shared_models.md"
```

### From another repository

```yaml
- uses: lidholm/flutter_platform_kit/tools/github_actions/copy-shared-models-to-docs@main
  with:
    source_models_path: "lib/sharedModels"
    output_path: "docs/shared_models.md"
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `source_models_path` | Path to Dart shared models (file or directory), relative to project root | `tools/freezed_to_ts/test_data` |
| `output_path` | Path to the output Markdown file, relative to project root | `docs/shared_models.md` |
| `freezed_to_ts_path` | Path to the `freezed_to_ts` package | `tools/freezed_to_ts` |
| `project_root` | Project root directory | `${{ github.workspace }}` |
| `dart_sdk` | Dart SDK version | `3.5` |
| `enabled` | Whether to run the step | `true` |

## Example workflow

See [example-workflow.yml](example-workflow.yml) for a minimal workflow that runs the action.
