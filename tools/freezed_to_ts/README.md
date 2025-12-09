# Freezed to TypeScript Converter

A simple command-line tool to convert Dart classes using the `freezed` package into TypeScript interfaces.

## Overview

This script works by parsing the Dart source code directly using the official `analyzer` package. It builds an Abstract Syntax Tree (AST) to reliably find `@freezed` annotated classes and their default factory constructors.

It then inspects the parameters of the constructor to determine the field names and types, and generates a corresponding TypeScript interface.

## Features

* Handles simple types
* Handles nested classes, that eventually evaluate to a simple type
* Handles ` @JsonKey(fromJson: fromDateTime, toJson: toDateTime)` with basic types 
* Converts single file or a directory of files

## How to Use

The script can be run from a local clone (ideal for development) or activated globally from GitHub or pub.dev (once published).

### Command-Line Options

*   `-i, --input`: (Required) The path to a single `.dart` file or a directory containing `.dart` files to process.
*   `-o, --output`: (Optional) The directory where generated `.ts` files should be written. If this is not provided, the output will be printed to the console.

### Examples

#### Running from a local clone

```sh
# Process a single file and print to console
dart run freezed_to_ts -i ../../packages/anyhoo_core/lib/src/models/user.dart

# Process a directory and write the output to a 'types' folder
dart run freezed_to_ts -i ../../packages/anyhoo_core/lib/src/models -o ./types
```

#### Running as a global executable:

```sh
# Activate from GitHub
dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/freezed_to_ts

# Run from anywhere
freezed_to_ts -i path/to/your/models -o path/to/your/ts/types


# Using a tag/version:
   dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/freezed_to_ts --git-ref v0.0.1

# Using a branch:
   dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --git-path tools/freezed_to_ts --git-ref main

# Using a commit hash:
   dart pub global activate --source git https://github.com/lidholm/flutter_platform_ts.git --git-path tools/freezed_to_ts --git-ref abc123def456
```

## Testing

The tool has a test suite to ensure the conversion logic is correct. To run the tests:

1.  Navigate to the `tools/freezed_to_ts` directory.
2.  Run the test command:
    ```sh
    dart test
    ```

## Next Steps

This tool is currently a simple prototype. Here are some potential features and improvements for the future:

- [x] **Handle Nested Classes**: The script now correctly handles nested `freezed` classes. It identifies all `@freezed` classes in the input files and uses their names as types in the generated TypeScript interfaces.
- [x] **Respect `@JsonKey` Annotation**: The script now parses the `@JsonKey(name: '...')` annotation and uses the specified name in the TypeScript output. It also applies a heuristic for `@JsonKey(fromJson: ..., toJson: ...)` to correctly type fields as `Timestamp` when `fromDateTime` or `toDateTime` conversion functions are referenced.
- [x] **File Output**: Add an `--output` flag to write the generated interface directly to a specified `.ts` file. *(In Progress)*
- [x] **Directory Processing**: Add functionality to process all `freezed` files within a given directory instead of just a single file. *(In Progress)*
- [ ] **Improved Error Handling**: Provide more specific error messages if a file can't be parsed or a valid `freezed` class isn't found.
- [x] **Handle type convertions**: Handle if a type is being converted to/from JSON types, e.g. DateTime to Timestamp
