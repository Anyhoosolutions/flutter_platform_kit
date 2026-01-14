#!/bin/bash

# Script to encrypt sensitive files with SOPS
# This script reads the secrets-config.txt file to determine which files to encrypt
# Can be used from any repository by passing the project directory as an argument
#
# Usage:
#   /path/to/flutter_platform_kit/tools/sops_secrets/encrypt-secrets.sh [PROJECT_DIR]
#
# If PROJECT_DIR is not provided, it uses the current working directory.

set -e

# Get the script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get project directory (default to current directory)
PROJECT_DIR="${1:-$(pwd)}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo "🔐 Encrypting sensitive files with SOPS..."
echo "📁 Project directory: $PROJECT_DIR"

# Check if SOPS is installed
if ! command -v sops &> /dev/null; then
    echo "❌ SOPS is not installed. Please install it first:"
    echo "   macOS: brew install sops"
    echo "   Linux: https://github.com/mozilla/sops#install"
    exit 1
fi

# Check if .sops.yaml exists in project directory
if [ ! -f "$PROJECT_DIR/.sops.yaml" ]; then
    echo "❌ .sops.yaml not found in $PROJECT_DIR"
    echo "   Please create .sops.yaml with your age key in the project root."
    echo ""
    echo "   Example .sops.yaml:"
    echo "   creation_rules:"
    echo "       - age: 'YOUR_AGE_PUBLIC_KEY_HERE'"
    exit 1
fi

# Check if secrets-config.txt exists in project directory
CONFIG_FILE="$PROJECT_DIR/scripts/secrets-config.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ secrets-config.txt not found at $CONFIG_FILE"
    echo "   Please create scripts/secrets-config.txt in your project root."
    echo "   Format: |filename|directory|"
    echo "   Example: |.env|.|"
    exit 1
fi

# Function to encrypt a file
encrypt_file() {
    local file_path="$1"
    local encrypted_path="$2"

    if [ -f "$file_path" ]; then
        # Check if we need to re-encrypt
        local needs_encryption=true
        
        if [ -f "$encrypted_path" ]; then
            # Check if encrypted file is newer than source file
            # The -nt operator returns true if file1 is newer than file2 (based on mtime)
            if [ "$encrypted_path" -nt "$file_path" ]; then
                # Encrypted file is newer than source, but also check if .sops.yaml changed
                # (which would require re-encryption even if timestamps say otherwise)
                if [ -f "$PROJECT_DIR/.sops.yaml" ] && [ "$PROJECT_DIR/.sops.yaml" -nt "$encrypted_path" ]; then
                    # .sops.yaml is newer, need to re-encrypt
                    needs_encryption=true
                else
                    # Encrypted file is newer and .sops.yaml hasn't changed
                    needs_encryption=false
                fi
            fi
            # If encrypted file is not newer (or equal), we need to encrypt
        fi
        # If encrypted file doesn't exist, we need to encrypt
        
        if [ "$needs_encryption" = false ]; then
            echo "⏭️  Skipping $file_path (already up to date)"
            return
        fi

        echo "📁 Encrypting $file_path..."
        # Get relative path from project directory
        if [[ "$file_path" == "$PROJECT_DIR"* ]]; then
            relative_path="${file_path#$PROJECT_DIR/}"
        else
            relative_path="$file_path"
        fi
        # Change to project directory so SOPS uses the correct .sops.yaml
        (cd "$PROJECT_DIR" && sops -e "$relative_path") > "$encrypted_path"
        echo "✅ Encrypted $file_path -> $encrypted_path"
    else
        echo "⚠️  File $file_path not found, skipping..."
    fi
}

# Create secrets directory if it doesn't exist
SECRETS_DIR="$PROJECT_DIR/secrets"
mkdir -p "$SECRETS_DIR"

# Read secrets configuration and encrypt files
echo "📋 Reading secrets configuration from $CONFIG_FILE..."
while IFS='|' read -r field1 filename directory field4; do
    # Skip empty lines and comments
    if [[ -z "$filename" || "$filename" =~ ^[[:space:]]*# ]]; then
        continue
    fi

    # Remove leading/trailing whitespace
    filename=$(echo "$filename" | xargs)
    directory=$(echo "$directory" | xargs)

    # Construct the full file path
    if [[ "$directory" == "." ]]; then
        file_path="$PROJECT_DIR/$filename"
        encrypted_path="$SECRETS_DIR/${filename}.enc"
    else
        file_path="$PROJECT_DIR/${directory}/${filename}"
        encrypted_path="$SECRETS_DIR/${directory}/${filename}.enc"
    fi

    if [[ -n "$filename" && -n "$directory" ]]; then
        # Create the directory structure in secrets/ if needed
        mkdir -p "$(dirname "$encrypted_path")"
        encrypt_file "$file_path" "$encrypted_path"
    fi
done < "$CONFIG_FILE"

echo ""
echo "🎉 Encryption complete!"
echo ""
echo "📋 Next steps:"
echo "1. Add the encrypted files to git:"
echo "   git add secrets/"
echo ""
echo "2. Make sure your original files are in .gitignore"
echo ""
echo "3. Your CI/CD workflow should decrypt these files before use"
echo ""
echo "⚠️  Remember to keep your original files secure and backup your age key!"
echo "⚠️  Each repository should have its own .sops.yaml with its own age key"
