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

echo "Creating Flutter package: $PACKAGE_NAME"
cd "$PROJECT_ROOT/packages" || exit 1

flutter create --template=package "$PACKAGE_NAME"

# Create the library export file
echo "Creating library export file: $LIB_FILE"

cat > "$LIB_FILE" << EOF
/// $PACKAGE_NAME_PASCAL Package
///
/// <Brief description of what the package does>
library $PACKAGE_NAME;

// Add exports for all public API files
// export 'path/to/public_file1.dart';
// export 'path/to/public_file2.dart';
EOF

echo "✅ Package created successfully at $PACKAGE_DIR"
echo "📝 Library file created at $LIB_FILE"
echo ""
echo "Next steps:"
echo "1. Update the library file description"
echo "2. Add your implementation files"
echo "3. Export them in the library file"

