#!/bin/bash
#
# Syncs documentation files to the docs directory:
# - Generates toc.json using the Dart toc_generator
# - Copies READMEs from packages (with CHANGELOGs appended at the bottom)
# - Copies GitHub Actions READMEs (with CHANGELOGs appended if they exist)
# - Copies package docs/ directories
# - Copies additional .md files from package roots
#
# Usage: ./scripts/sync_docs.sh [--skip-toc]
#
# Run this script before committing to ensure docs are up-to-date.
# CI will verify that this script has been run.

set -e

# Get the project root (script is in scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Configuration
DOCS_DIR="docs"
PACKAGE_DIRS="packages/*/ tools/*/"
TOC_GENERATOR_PATH="scripts/toc_generator"

# Parse arguments
SKIP_TOC=false
for arg in "$@"; do
  case $arg in
    --skip-toc)
      SKIP_TOC=true
      shift
      ;;
  esac
done

echo "📚 Syncing documentation..."
echo ""

# Generate toc.json
if [ "$SKIP_TOC" = false ]; then
  echo "📋 Generating toc.json..."
  cd "$TOC_GENERATOR_PATH"
  dart pub get --no-precompile > /dev/null 2>&1
  dart bin/generate_toc.dart
  cd "$PROJECT_ROOT"
  echo "✅ Generated toc.json"
  echo ""
fi

# Copy READMEs with CHANGELOGs appended
echo "📖 Copying READMEs (with CHANGELOGs appended)..."
for package_dir in $PACKAGE_DIRS; do
  [ -d "$package_dir" ] || continue
  package_name=$(basename "$package_dir")
  readme_path="$package_dir/README.md"
  changelog_path="$package_dir/CHANGELOG.md"
  
  if [ -f "$readme_path" ]; then
    mkdir -p "$DOCS_DIR/$package_name"
    # Start with the README content
    cp "$readme_path" "$DOCS_DIR/$package_name/README.md"
    
    # Append CHANGELOG if it exists
    if [ -f "$changelog_path" ]; then
      {
        echo ""
        echo "---"
        echo ""
        echo "## Changelog"
        echo ""
        # Convert ## headings to ### (add one # to version headings)
        sed 's/^## /### /' "$changelog_path"
      } >> "$DOCS_DIR/$package_name/README.md"
      echo "  ✅ $package_name/README.md (with Changelog)"
    else
      echo "  ✅ $package_name/README.md"
    fi
  fi
done
echo ""

# Copy GitHub Actions READMEs (with CHANGELOGs appended if they exist)
echo "🔧 Copying GitHub Actions READMEs..."
for action_dir in tools/github_actions/*/; do
  [ -d "$action_dir" ] || continue
  action_name=$(basename "$action_dir")
  readme_path="${action_dir}README.md"
  changelog_path="${action_dir}CHANGELOG.md"
  
  if [ -f "$readme_path" ]; then
    mkdir -p "$DOCS_DIR/$action_name"
    # Start with the README content
    cp "$readme_path" "$DOCS_DIR/$action_name/README.md"
    
    # Append CHANGELOG if it exists
    if [ -f "$changelog_path" ]; then
      {
        echo ""
        echo "---"
        echo ""
        echo "## Changelog"
        echo ""
        # Convert ## headings to ### (add one # to version headings)
        sed 's/^## /### /' "$changelog_path"
      } >> "$DOCS_DIR/$action_name/README.md"
      echo "  ✅ $action_name/README.md (with Changelog)"
    else
      echo "  ✅ $action_name/README.md"
    fi
    
    # Copy additional .md files (excluding README.md and CHANGELOG.md)
    find "$action_dir" -maxdepth 1 -type f -name "*.md" ! -name "README.md" ! -name "CHANGELOG.md" 2>/dev/null | while read -r doc_file; do
      filename=$(basename "$doc_file")
      cp "$doc_file" "$DOCS_DIR/$action_name/$filename"
      echo "  ✅ $action_name/$filename"
    done
  fi
done
echo ""

# Copy package docs directories
echo "📁 Copying package docs directories..."
for package_dir in $PACKAGE_DIRS; do
  [ -d "$package_dir" ] || continue
  package_name=$(basename "$package_dir")
  docs_dir="$package_dir/docs"
  
  if [ -d "$docs_dir" ]; then
    mkdir -p "$DOCS_DIR/$package_name"
    # Copy all .md files from the package's docs directory, preserving structure
    find "$docs_dir" -type f -name "*.md" | while read -r doc_file; do
      rel_path="${doc_file#$docs_dir/}"
      target_dir="$DOCS_DIR/$package_name/$(dirname "$rel_path")"
      mkdir -p "$target_dir"
      cp "$doc_file" "$DOCS_DIR/$package_name/$rel_path"
      echo "  ✅ $package_name/docs/$rel_path"
    done
  fi
done
echo ""

# Copy additional .md files from package root
echo "📄 Copying additional .md files..."
for package_dir in $PACKAGE_DIRS; do
  [ -d "$package_dir" ] || continue
  package_name=$(basename "$package_dir")
  
  # Find all .md files in package root that aren't README.md or CHANGELOG.md
  find "$package_dir" -maxdepth 1 -type f -name "*.md" ! -name "README.md" ! -name "CHANGELOG.md" 2>/dev/null | while read -r doc_file; do
    filename=$(basename "$doc_file")
    mkdir -p "$DOCS_DIR/$package_name"
    cp "$doc_file" "$DOCS_DIR/$package_name/$filename"
    echo "  ✅ $package_name/$filename"
  done
done
echo ""

echo "✨ Documentation sync complete!"
