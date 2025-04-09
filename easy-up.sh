#!/bin/bash

# easy-up.sh - Simple script to deploy the Helm chart
set -e

# Default values
NAMESPACE="default"
RELEASE_NAME="wraft"
ENV="dev"

# Help function
function show_help {
  echo "Usage: ./easy-up.sh [options]"
  echo ""
  echo "Options:"
  echo "  -n, --namespace NAMESPACE    Kubernetes namespace to deploy to (default: $NAMESPACE)"
  echo "  -r, --release RELEASE_NAME   Helm release name (default: $RELEASE_NAME)"
  echo "  -e, --env ENVIRONMENT        Environment to use (default: $ENV)"
  echo "  -h, --help                   Show this help message"
  echo ""
  echo "Example:"
  echo "  ./easy-up.sh --namespace myapp --release myrelease --env production"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    -r|--release)
      RELEASE_NAME="$2"
      shift 2
      ;;
    -e|--env)
      ENV="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

echo "🚀 Deploying $RELEASE_NAME to namespace $NAMESPACE using $ENV environment..."

# Check if values file for specified environment exists
ENV_VALUES="./environments/$ENV/values.yaml"
if [ ! -f "$ENV_VALUES" ]; then
  echo "❌ Environment values file not found: $ENV_VALUES"
  echo "Available environments:"
  ls -1 ./environments/
  exit 1
fi

# Build Helm dependencies if needed
echo "🔍 Checking chart dependencies..."
helm dependency build > /dev/null

# Deploy the Helm chart
echo "📦 Installing/upgrading Helm chart..."
helm upgrade --install $RELEASE_NAME . \
  --namespace $NAMESPACE \
  --create-namespace \
  --values values.yaml \
  --values $ENV_VALUES

# Add your node IP and ingress hostname to ensure MinIO functions correctly
echo "$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')  minio-api.local" | sudo tee -a /etc/hosts

echo "✅ Deployment complete! Your application should be up shortly."
echo "📊 To check status, run: kubectl get pods -n $NAMESPACE"