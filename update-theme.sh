#!/bin/bash

# Exit on error
set -e

# Check if source directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-theme-directory>"
    echo "Example: $0 ./minimal-mistakes-master"
    exit 1
fi

THEME_DIR="$1"
if [ ! -d "$THEME_DIR" ]; then
    echo "Error: Theme directory '$THEME_DIR' not found!"
    exit 1
fi

echo "Starting Minimal Mistakes theme update process..."

BACKUP_DIR="theme_backup_$(date +%Y%m%d_%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup existing theme files that might have customizations
echo "Creating backup of current theme files..."
for dir in _layouts _includes assets _sass _data; do
    if [ -d "$dir" ]; then
        echo "Backing up $dir..."
        cp -R "$dir" "$BACKUP_DIR/"
    fi
done

# Backup important files
IMPORTANT_FILES=(
    "_config.yml"
    "package.json"
    "package-lock.json"
    "Gemfile"
    "Gemfile.lock"
    "staticman.yml"
    "index.html"
    "minimal-mistakes-jekyll.gemspec"
    "Rakefile"
)

for file in "${IMPORTANT_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Backing up $file..."
        cp "$file" "$BACKUP_DIR/"
    fi
done

# Update theme files
echo "Updating theme files from: $THEME_DIR"

# Core theme directories to update
THEME_DIRS=(_layouts _includes assets _sass)
for dir in "${THEME_DIRS[@]}"; do
    if [ -d "$THEME_DIR/$dir" ]; then
        echo "Updating $dir..."
        rm -rf "$dir"
        cp -R "$THEME_DIR/$dir" .
    fi
done

# Files that need careful merging
MERGE_FILES=(
    "package.json"
    "package-lock.json"
    "Gemfile"
    "minimal-mistakes-jekyll.gemspec"
    "Rakefile"
)

echo "Checking for files that need manual merging..."
for file in "${MERGE_FILES[@]}"; do
    if [ -f "$THEME_DIR/$file" ]; then
        if [ -f "$file" ]; then
            echo "ATTENTION: $file exists in both directories."
            echo "Original backed up at: $BACKUP_DIR/$file"
            echo "New version available at: $THEME_DIR/$file"
            echo "Please manually merge changes if needed."
        else
            echo "Adding new file: $file"
            cp "$THEME_DIR/$file" .
        fi
    fi
done

# No cleanup needed for local directory

echo "Theme update complete!"
echo "Backup of original files stored in: $BACKUP_DIR"
echo ""
echo "Please review the following files for any customizations that need to be reapplied:"
echo "1. Check files in $BACKUP_DIR/_layouts/ against new _layouts/"
echo "2. Check files in $BACKUP_DIR/_includes/ against new _includes/"
echo "3. Check files in $BACKUP_DIR/assets/ against new assets/"
echo "4. Check files in $BACKUP_DIR/_sass/ against new _sass/"
echo ""
echo "Files that need manual review:"
echo "1. Configuration files (kept unchanged):"
echo "   - _config.yml"
echo "   - _data/navigation.yml"
echo "   - _data/ui-text.yml"
echo ""
echo "2. Package management files (may need manual merging):"
echo "   - package.json"
echo "   - package-lock.json"
echo "   - Gemfile"
echo "   - minimal-mistakes-jekyll.gemspec"
echo ""
echo "3. Build files:"
echo "   - Rakefile"
echo ""
echo "Steps to complete the update:"
echo "1. Review all changes in theme files (_layouts, _includes, assets, _sass)"
echo "2. Check package management files for version updates"
echo "3. Update dependencies if needed: 'bundle update' and 'npm install'"
echo "4. Test your site thoroughly before deploying"
echo ""
echo "All original files are backed up in: $BACKUP_DIR"
echo "After verifying all changes, you may delete the backup directory"