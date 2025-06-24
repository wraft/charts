#!/bin/bash
# validate.sh - A script to validate the Wraft Helm chart
# Usage: ./validate.sh [namespace]

set -e

NAMESPACE=${1:-default}
CHART_DIR="$(pwd)"

echo "🔍 Validating Wraft Helm chart in $CHART_DIR..."

# Check for required tools
for cmd in helm; do
  if ! command -v $cmd &> /dev/null; then
    echo "❌ Error: $cmd is required but not installed."
    exit 1
  fi
done

echo "✅ Required tools found"

# Lint the chart
echo "🔍 Linting chart..."
helm lint "$CHART_DIR"

# Validate templates
echo "🔍 Validating templates..."
helm template "$CHART_DIR" > /dev/null && echo "✅ Templates validated successfully"

# Check YAML files with yamllint if available
if command -v yamllint &> /dev/null; then
  echo "🔍 Checking YAML files with yamllint..."
  find "$CHART_DIR" -name "*.yaml" -not -path "*/\.*" | xargs yamllint -d relaxed
else
  echo "⚠️ yamllint not found, skipping YAML linting"
fi

echo "✅ Validation complete!"
echo "📝 Note: This is a basic validation. For production, consider using additional tools like:"
echo "  - helm-unittest"
echo "  - kubeval"
echo "  - conftest"
echo "  - polaris"
echo "  - yamllint (for YAML syntax validation)"

exit 0 