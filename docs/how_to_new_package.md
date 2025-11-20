# Create a new package

## Command

Go to the `packages` directory and run the command `flutter create --template=package <package-name>`.
It will create a simple implementation file and test file among other files.

## Library Export File

The default template creates a single implementation file (e.g., `<package-name>.dart`) with example code. For packages with multiple files, you should convert this to a library export file that defines the public API.

Replace the default implementation with:

```dart
/// <Package Description>
///
/// <Brief description of what the package does>
library <package_name>;

export 'path/to/public_file1.dart';
export 'path/to/public_file2.dart';
// Add exports for all public API files
```

**Why use this pattern?**
- Acts as the public API entry point
- Keeps the API surface clean and stable
- Makes refactoring easier (internal files can be moved without breaking users)
- Files not exported remain internal to the package

See `packages/image_selector/lib/image_selector.dart` for an example.


