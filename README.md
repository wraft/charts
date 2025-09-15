# Wraft Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/wraft)](https://artifacthub.io/packages/helm/wraft/wraft)

Helm charts for deploying Wraft on Kubernetes.

## Quick Start

```bash
# Add the Wraft Helm repository
helm repo add wraft https://wraft.github.io/charts

# Install Wraft
helm install wraft wraft/wraft
```

## Installation Options

```bash
# Install specific version
helm install wraft wraft/wraft --version 0.1.9

# Install with custom values
helm install wraft wraft/wraft --values my-values.yaml

# Install to specific namespace
helm install wraft wraft/wraft --namespace wraft --create-namespace
```

## What's Included

- Frontend web interface
- Backend API services
- PostgreSQL database
- Typesense search engine
- MinIO object storage
- Ingress configurations

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Minimum 2 vCPUs, 4GB RAM, 20GB storage

## Documentation

- [Chart Documentation](charts/wraft/README.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
