#!/bin/bash
# update-version.sh - A script to update the Wraft Helm chart version
# Usage: ./update-version.sh <new-version>

set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <new-version>"
  echo "Example: $0 0.2.0"
  exit 1
fi

NEW_VERSION=$1
CHART_FILE="Chart.yaml"

if [ ! -f "$CHART_FILE" ]; then
  echo "❌ Error: $CHART_FILE not found in current directory."
  exit 1
fi

# Update version in Chart.yaml
echo "📝 Updating version in $CHART_FILE to $NEW_VERSION..."
sed -i.bak "s/^version:.*/version: $NEW_VERSION/" "$CHART_FILE"
rm -f "${CHART_FILE}.bak"

# Update CHANGELOG.md
CHANGELOG_FILE="CHANGELOG.md"
if [ -f "$CHANGELOG_FILE" ]; then
  echo "📝 Updating $CHANGELOG_FILE..."
  DATE=$(date +"%Y-%m-%d")
  
  # Create new entry at the top of the changelog
  NEW_ENTRY="## [$NEW_VERSION] - $DATE\n\n### Added\n- \n\n### Changed\n- \n\n### Fixed\n- \n\n"
  
  # Insert new entry after the first line
  sed -i.bak "1a\\
$NEW_ENTRY" "$CHANGELOG_FILE"
  rm -f "${CHANGELOG_FILE}.bak"
  
  echo "✅ $CHANGELOG_FILE updated. Please fill in the details."
fi

echo "✅ Version updated to $NEW_VERSION"
echo "📝 Don't forget to:"
echo "  1. Update the CHANGELOG.md with your changes"
echo "  2. Commit the changes"
echo "  3. Create a git tag for the new version"
echo "     git tag -a wraft-$NEW_VERSION -m \"Release wraft-$NEW_VERSION\""

exit 0 