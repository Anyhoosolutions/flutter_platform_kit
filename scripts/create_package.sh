#!/bin/bash

# Script to create a new Flutter package with a library export file
# Usage: ./scripts/create_package.sh <package-name>

set -e

if [ $# -eq 0 ]; then
    echo "Error: Package name is required"
    echo "Usage: ./scripts/create_package.sh <package-name>"
    exit 1
fi

PACKAGE_NAME=$1

# Convert package name to PascalCase for description
PACKAGE_NAME_PASCAL=$(echo "$PACKAGE_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PACKAGE_DIR="$PROJECT_ROOT/packages/$PACKAGE_NAME"
LIB_FILE="$PACKAGE_DIR/lib/$PACKAGE_NAME.dart"
CALCULATOR_FILE="$PACKAGE_DIR/lib/src/calculator.dart"
OLD_TEST_FILE="$PACKAGE_DIR/test/${PACKAGE_NAME}_test.dart"
CALCULATOR_TEST_FILE="$PACKAGE_DIR/test/src/calculator_test.dart"

echo "Creating Flutter package: $PACKAGE_NAME"
cd "$PROJECT_ROOT/packages" || exit 1

flutter create --template=package "$PACKAGE_NAME"

# Create src directory if it doesn't exist
mkdir -p "$PACKAGE_DIR/lib/src"

# Move the original Calculator file from the default location to src/calculator.dart
echo "Moving Calculator example file to: $CALCULATOR_FILE"
mv "$LIB_FILE" "$CALCULATOR_FILE"

# Create the library export file
echo "Creating library export file: $LIB_FILE"

cat > "$LIB_FILE" << EOF
/// $PACKAGE_NAME_PASCAL Package
///
/// <Brief description of what the package does>
library $PACKAGE_NAME;

export 'src/calculator.dart';

// Add exports for all public API files
// export 'path/to/public_file1.dart';
// export 'path/to/public_file2.dart';
EOF

# Move and rename the test file to match the Calculator structure
if [ -f "$OLD_TEST_FILE" ]; then
  echo "Moving test file to: $CALCULATOR_TEST_FILE"
  mkdir -p "$PACKAGE_DIR/test/src"
  
  # Move the file (import statement should already be correct)
  cp "$OLD_TEST_FILE" "$CALCULATOR_TEST_FILE"
  
  # Remove the old test file
  rm "$OLD_TEST_FILE"
fi

echo "✅ Package created successfully at $PACKAGE_DIR"
echo "📝 Library file created at $LIB_FILE"
echo "📝 Calculator example file created at $CALCULATOR_FILE"
echo "📝 Calculator test file created at $CALCULATOR_TEST_FILE"
echo ""
echo "Next steps:"
echo "1. Update the library file description"
echo "2. Add your implementation files"
echo "3. Export them in the library file"
echo "4. Add section to docs/toc.json"
echo "5. Update the pubspec.yaml file with homepage and publish_to"

