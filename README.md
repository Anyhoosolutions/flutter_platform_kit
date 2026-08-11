# README

## Overview

A selection of widgets and other tools, such as a router collection, for building a Flutter app.

## Development

This repo is a Melos + Dart pub workspace monorepo.

```bash
# Install and link all workspace packages
dart pub get
dart run melos bootstrap
# Or, if Melos is activated globally: melos bootstrap

# Analyze / test across the workspace
dart run melos run analyze
dart run melos run test
```

Useful filters:

```bash
dart run melos exec --category=libs -- flutter test
dart run melos exec --scope="anyhoo_*" -- flutter analyze
```

Note: `tools/upload_documentation` and `tools/freezed_to_ts` are outside the workspace for now (Freezed 2.x vs Freezed 3.x elsewhere). Manage those packages with a local `dart pub get`.
