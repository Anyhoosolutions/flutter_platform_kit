#!/bin/bash

# Script to decrypt sensitive files with SOPS
# This script reads the secrets-config.txt file to determine which files to decrypt
# Can be used from any repository by passing the project directory as an argument
#
# Usage:
#   /path/to/flutter_platform_kit/tools/sops_secrets/decrypt-secrets.sh [PROJECT_DIR]
#
# If PROJECT_DIR is not provided, it uses the current working directory.
# The age key can be provided via:
#   - SOPS_AGE_KEY environment variable (recommended for CI/CD)
#   - age-key.txt file in the project root (for local development)

set -e

# Get the script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get project directory (default to current directory)
PROJECT_DIR="${1:-$(pwd)}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo "🔓 Decrypting sensitive files with SOPS..."
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
    exit 1
fi

# Check if secrets-config.txt exists in project directory
CONFIG_FILE="$PROJECT_DIR/scripts/secrets-config.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ secrets-config.txt not found at $CONFIG_FILE"
    echo "   Please create scripts/secrets-config.txt in your project root."
    exit 1
fi

# Set up age key if available
AGE_KEY_FILE="$PROJECT_DIR/age-key.txt"
if [ -f "$AGE_KEY_FILE" ]; then
    export SOPS_AGE_KEY_FILE="$AGE_KEY_FILE"
    echo "✅ Using age key from $AGE_KEY_FILE"
elif [ -n "$SOPS_AGE_KEY" ]; then
    # Use temporary file for environment variable
    TEMP_KEY_FILE=$(mktemp)
    echo "$SOPS_AGE_KEY" > "$TEMP_KEY_FILE"
    export SOPS_AGE_KEY_FILE="$TEMP_KEY_FILE"
    trap "rm -f $TEMP_KEY_FILE" EXIT
    echo "✅ Using age key from SOPS_AGE_KEY environment variable"
elif [ -n "$SOPS_AGE_KEY_FILE" ]; then
    echo "✅ Using age key from SOPS_AGE_KEY_FILE: $SOPS_AGE_KEY_FILE"
else
    echo "⚠️  No age key found. Please set one of:"
    echo "   - SOPS_AGE_KEY environment variable"
    echo "   - SOPS_AGE_KEY_FILE environment variable"
    echo "   - age-key.txt file in project root"
    exit 1
fi

# Function to decrypt a file
decrypt_file() {
    local encrypted_path="$1"
    local decrypted_path="$2"

    if [ -f "$encrypted_path" ]; then
        echo "📁 Decrypting $encrypted_path..."

        # Determine output type based on file extension
        local output_type=""
        case "$decrypted_path" in
            *.json)
                output_type="--output-type=json"
                ;;
            *.yaml|*.yml)
                output_type="--output-type=yaml"
                ;;
            *.env)
                output_type="--output-type=dotenv"
                ;;
            *.plist)
                output_type="--output-type=binary"
                ;;
            *)
                output_type=""
                ;;
        esac

        # Get relative path from project directory
        local relative_encrypted_path
        if [[ "$encrypted_path" == "$PROJECT_DIR"* ]]; then
            relative_encrypted_path="${encrypted_path#$PROJECT_DIR/}"
        else
            relative_encrypted_path="$encrypted_path"
        fi
        
        # Change to project directory so SOPS uses the correct .sops.yaml
        # Special handling for .env files that might have formatting issues
        if [[ "$decrypted_path" == *.env ]]; then
            if (cd "$PROJECT_DIR" && sops -d --input-type=dotenv --output-type=dotenv "$relative_encrypted_path") > "$decrypted_path" 2>/dev/null; then
                echo "✅ Decrypted $encrypted_path -> $decrypted_path (dotenv format)"
            elif (cd "$PROJECT_DIR" && sops -d --input-type=dotenv "$relative_encrypted_path") > "$decrypted_path" 2>/dev/null; then
                echo "✅ Decrypted $encrypted_path -> $decrypted_path (dotenv input)"
            elif (cd "$PROJECT_DIR" && sops -d "$relative_encrypted_path") > "$decrypted_path" 2>/dev/null; then
                echo "✅ Decrypted $encrypted_path -> $decrypted_path (auto-detect)"
            else
                echo "❌ Failed to decrypt $encrypted_path with any method"
                echo "⚠️  The encrypted file may be corrupted or encrypted with a different key"
                return 1
            fi
        else
            if (cd "$PROJECT_DIR" && sops -d $output_type "$relative_encrypted_path") > "$decrypted_path"; then
                echo "✅ Decrypted $encrypted_path -> $decrypted_path"
            else
                echo "❌ Failed to decrypt $encrypted_path"
                return 1
            fi
        fi

        # Show file size to confirm it was written
        if [ -f "$decrypted_path" ]; then
            echo "📏 File size: $(wc -c < "$decrypted_path") bytes"
        fi
    else
        echo "⚠️  File $encrypted_path not found, skipping..."
        return 1
    fi
}

# Show what encrypted files exist
echo "📋 Checking for encrypted files in secrets/ directory..."
SECRETS_DIR="$PROJECT_DIR/secrets"
if [ -d "$SECRETS_DIR" ]; then
    echo "📁 Files in secrets/ directory:"
    ls -la "$SECRETS_DIR" || echo "No files found in secrets/"
else
    echo "❌ secrets/ directory not found"
fi

# Parse secrets configuration into arrays
echo "📋 Reading secrets configuration from $CONFIG_FILE..."
declare -a filenames=()
declare -a directories=()
declare -a file_paths=()
declare -a encrypted_paths=()

while read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi

    # Remove leading/trailing whitespace and pipe characters
    line=$(echo "$line" | sed 's/^|*//; s/|*$//')

    # Split on pipe character and extract fields
    # Format: |filename|directory|
    # We expect exactly 2 fields between pipes
    if [[ "$line" =~ ^([^|]+)\|([^|]+)$ ]]; then
        filename="${BASH_REMATCH[1]}"
        directory="${BASH_REMATCH[2]}"

        # Remove leading/trailing whitespace
        filename=$(echo "$filename" | xargs)
        directory=$(echo "$directory" | xargs)

        # Construct the full file path and encrypted path
        if [[ "$directory" == "." ]]; then
            file_path="$PROJECT_DIR/$filename"
            encrypted_path="$SECRETS_DIR/${filename}.enc"
        else
            file_path="$PROJECT_DIR/${directory}/${filename}"
            encrypted_path="$SECRETS_DIR/${directory}/${filename}.enc"
        fi

        if [[ -n "$filename" && -n "$directory" ]]; then
            filenames+=("$filename")
            directories+=("$directory")
            file_paths+=("$file_path")
            encrypted_paths+=("$encrypted_path")
        fi
    else
        echo "⚠️  Skipping malformed line: $line"
    fi
done < "$CONFIG_FILE"

# Decrypt files
for i in "${!filenames[@]}"; do
    filename="${filenames[$i]}"
    file_path="${file_paths[$i]}"
    encrypted_path="${encrypted_paths[$i]}"
    directory="${directories[$i]}"
    echo ""
    echo "🔍 Processing: $filename -> $file_path"
    # Create the directory structure if needed
    if [[ "$directory" != "." ]]; then
        mkdir -p "$PROJECT_DIR/$directory"
    fi
    decrypt_file "$encrypted_path" "$file_path" || true
done

echo ""
echo "📋 Summary:"
for i in "${!filenames[@]}"; do
    filename="${filenames[$i]}"
    file_path="${file_paths[$i]}"
    if [ -f "$file_path" ]; then
        echo "✅ $filename - Ready for use at $file_path"
    else
        echo "❌ $filename - Not available at $file_path"
    fi
done

# Check if .env was decrypted and perform replacements
ENV_FILE="$PROJECT_DIR/.env"
if [ -f "$ENV_FILE" ]; then
    echo ""
    echo "🔧 .env file found, performing secret replacements..."

    # Check if secrets-replace-config.txt exists
    REPLACE_CONFIG_FILE="$PROJECT_DIR/scripts/secrets-replace-config.txt"
    if [ -f "$REPLACE_CONFIG_FILE" ]; then
        echo "📋 Reading replacement configuration from $REPLACE_CONFIG_FILE..."

        # Function to replace placeholder with actual value
        replace_secret() {
            local var_name="$1"
            local file_path="$2"

            # Get the value from .env file
            local value=$(grep "^${var_name}=" "$ENV_FILE" | cut -d'=' -f2- | sed 's/^"//; s/"$//')

            if [ -n "$value" ]; then
                echo "🔄 Replacing ${var_name} in ${file_path}..."

                # Create a temporary file for sed (works on both macOS and Linux)
                local temp_file=$(mktemp)
                
                # Replace the placeholder with the actual value
                if sed "s|${var_name}|${value}|g" "$file_path" > "$temp_file"; then
                    mv "$temp_file" "$file_path"
                    echo "✅ Replaced ${var_name} in ${file_path}"
                else
                    rm -f "$temp_file"
                    echo "❌ Failed to replace ${var_name} in ${file_path}"
                fi
            else
                echo "⚠️  Variable ${var_name} not found in .env file"
            fi
        }

        # Parse replacement configuration
        while read -r line; do
            # Skip empty lines and comments
            if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
                continue
            fi

            # Remove leading/trailing whitespace and pipe characters
            line=$(echo "$line" | sed 's/^|*//; s/|*$//')

            # Split on pipe character and extract fields
            # Format: |variable name|filepath|
            if [[ "$line" =~ ^([^|]+)\|([^|]+)$ ]]; then
                var_name="${BASH_REMATCH[1]}"
                file_path="${BASH_REMATCH[2]}"

                # Remove leading/trailing whitespace
                var_name=$(echo "$var_name" | xargs)
                file_path=$(echo "$file_path" | xargs)

                # Make file path absolute if it's relative
                if [[ "$file_path" != /* ]]; then
                    file_path="$PROJECT_DIR/$file_path"
                fi

                if [[ -n "$var_name" && -n "$file_path" ]]; then
                    if [ -f "$file_path" ]; then
                        replace_secret "$var_name" "$file_path"
                    else
                        echo "⚠️  File $file_path not found, skipping replacement for $var_name"
                    fi
                fi
            else
                echo "⚠️  Skipping malformed replacement line: $line"
            fi
        done < "$REPLACE_CONFIG_FILE"

        echo "✅ Secret replacements complete!"
    else
        echo "⚠️  $REPLACE_CONFIG_FILE not found, skipping replacements"
    fi
else
    echo "⚠️  .env file not found, skipping secret replacements"
fi

echo ""
echo "🎉 Decryption complete!"
echo ""
echo "📋 Files are now ready for use:"
for i in "${!file_paths[@]}"; do
    echo "- ${file_paths[$i]}"
done
