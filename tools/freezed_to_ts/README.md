# Freezed to TypeScript Converter

A simple command-line tool to convert Dart classes using the `freezed` package into TypeScript interfaces.

## Overview

This script works by parsing the Dart source code directly using the official `analyzer` package. It builds an Abstract Syntax Tree (AST) to reliably find `@freezed` annotated classes and their default factory constructors.

It then inspects the parameters of the constructor to determine the field names and types, and generates a corresponding TypeScript interface.

## How to Use

To use this tool, you have a few options:

### Running from a local clone (for development/testing)

1.  Navigate to the `tools/freezed_to_ts` directory.
2.  If you haven't already, fetch the dependencies:
    ```sh
    dart pub get
    ```
3.  Run the script, providing the path to the Dart file you want to convert.

    ```sh
    dart run freezed_to_ts --path ../../packages/anyhoo_core/lib/src/models/user.dart
    ```

### Running Directly from GitHub (before publishing to pub.dev)

You can activate and run the tool directly from its GitHub repository. This is useful for trying it out before it's officially published to pub.dev, or if you prefer to use a specific version from the repository.

1.  Activate the tool globally from the Git repository:
    ```sh
    dart pub global activate --source git https://github.com/lidholm/flutter_platform_kit.git --path tools/freezed_to_ts
    ```
    *Note: The `--path tools/freezed_to_ts` argument is crucial to specify the subdirectory within the repository where the package is located.*

2.  Once activated, you can run the `freezed_to_ts` command from anywhere:
    ```sh
    freezed_to_ts --path path/to/your/freezed_file.dart
    ```

    To update the tool later, simply run the `dart pub global activate` command again.

*Caveat: While convenient, activating directly from Git makes the command to install quite long. Publishing to `pub.dev` will provide the most user-friendly installation experience.*

The generated TypeScript interface will be printed to the console.

## Testing

The tool has a test suite to ensure the conversion logic is correct. To run the tests:

1.  Navigate to the `tools/freezed_to_ts` directory.
2.  Run the test command:
    ```sh
    dart test
    ```

## Next Steps

This tool is currently a simple prototype. Here are some potential features and improvements for the future:

- [ ] **Handle Nested Classes**: Currently, if a `freezed` class contains another custom class as a property, it is treated as type `any`. The script could be enhanced to find and convert nested classes as well.
- [ ] **Respect `@JsonKey` Annotation**: The script could parse the `@JsonKey(name: '...')` annotation and use the specified name in the TypeScript output.
- [ ] **File Output**: Add an `--output` flag to write the generated interface directly to a specified `.ts` file.
- [ ] **Directory Processing**: Add functionality to process all `freezed` files within a given directory instead of just a single file.
- [ ] **Improved Error Handling**: Provide more specific error messages if a file can't be parsed or a valid `freezed` class isn't found.
