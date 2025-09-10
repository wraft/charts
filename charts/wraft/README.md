# Wraft Helm Chart

  <p><strong>Wraft is an open-source content authoring platform that's helps businesses produce their most important set of documents. Wraft helps author structured business content. From official letters to contracts, and beyond.

Our goal is to give people complete control over their most important documents, from drafting to collaborating and distributing.

Wraft is built on top of open formats, using markdown and JSON. This means your content is always accessible and future-proof.
</strong></p>

## TL;DR

```bash
helm repo add wraft https://wraft.github.io/charts
helm install wraft wraft/wraft
```

## Prerequisites

- Kubernetes 1.16+
- Helm 3.1.0+
- PV provisioner support in the underlying infrastructure

## Installing the chart

To install the chart with the release name `wraft`:

```console
$ helm install wraft wraft/wraft
```

The command deploys wraft on the Kubernetes cluster in the default configuration. The [parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

### Parameters

| Parameter             | Description                           | Default        |
| --------------------- | ------------------------------------- | -------------- |
| `replicaCount`        | Number of replicas for the deployment | `1`            |
| `image.repository`    | Image repository                      | `wraft`        |
| `image.tag`           | Image tag                             | `latest`       |
| `image.pullPolicy`    | Image pull policy                     | `IfNotPresent` |
| `service.type`        | Kubernetes service type               | `ClusterIP`    |
| `service.port`        | Service port                          | `80`           |
| `resources.limits`    | Resource limits                       | `{}`           |
| `resources.requests`  | Resource requests                     | `{}`           |
| `persistence.enabled` | Enable persistent storage             | `false`        |
| `persistence.size`    | Size of persistent volume             | `10Gi`         |
| `global.domain`       | Base domain for all services          | `example.com`  |

For a complete list of parameters, please refer to the [values.yaml](values.yaml) file.

### Environment Variables

| Name                        | Type                                                                     | Default Value     |
| --------------------------- | ------------------------------------------------------------------------ | ----------------- |
| `DOMAIN`                    | Domain suffix for ingress routing, service exposure, or SSL termination. | `"local"`         |
| `NAMESPACE`                 | K8s namespace                                                            | `""`              |
| `XELATEX_PATH`              | Path to XeLaTeX binary.                                                  | `"xelatex"`       |
| `SENTRY_DSN`                | Sentry error tracking                                                    | `""`              |
| `MIX_ENV`                   | Elixir runtime mode                                                      | `"dev"`           |
| `SECRET_KEY_BASE`           | Signing key for session & encryption.                                    | `"Auto-Generate"` |
| `GUARDIAN_KEY`              | signing key used by secutiry                                             | `"Auto-Generate"` |
| `DATABASE_URL`              | Full DB connection string.                                               | `""`              |
| `POSTGRES_USER`             | DB admin username.                                                       | `"postgres"`      |
| `POSTGRES_PASSWORD`         | DB admin password.                                                       | `""`              |
| `POSTGRES_DB`               | DB name.                                                                 | `"wraft-data"`    |
| `MINIO_BUCKET`              | Bucket name for MinIO.                                                   | `"wraft"`         |
| `TYPESENSE_API_KEY`         | API key for secure access to Typesense.                                  | `""`              |
| `CLOAK_KEY`                 | secret key to encrypt or mask (“cloak”) sensitive data.                  | `"Auto-Generate"` |
| `NEXT_PUBLIC_API_HOST`      | Baseurl of backend Api.                                                  | `""`              |
| `NEXT_PUBLIC_WEBSOCKET_URL` | secure WebSocket.                                                        | `""`              |

## Manual Installation

If you prefer more control, you can perform a manual installation:

```bash
# Clone this repository
git clone https://github.com/wraft/charts.git
cd charts

# Build the dependencies
helm dependency build

# Install the chart with the release name "wraft"
helm upgrade --install wraft . --values values.yaml --values environments/dev/values.yaml
```

### Installation with Custom Values

```bash
# Using a custom values file
helm install wraft . -f values.yaml

# Or overriding specific values
helm install wraft . --set replicaCount=3 --set service.type=LoadBalancer
```

### Post-Installation Setup

#### Update /etc/hosts

```bash
# Add your node IP and ingress hostname to ensure MinIO functions correctly
echo "$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')  minio-api.local api.local" | sudo tee -a /etc/hosts
```

## Quick Start

Use our `easy-up.sh` script for a simple deployment:

```bash
./easy-up.sh
```

This will deploy Wraft with default settings to your Kubernetes cluster.

### Script Options

| Option            | Description               | Default   |
| ----------------- | ------------------------- | --------- |
| `-n, --namespace` | Kubernetes namespace      | `default` |
| `-r, --release`   | Helm release name         | `wraft`   |
| `-e, --env`       | Environment configuration | `dev`     |
| `-h, --help`      | Show help message         | -         |

### Examples

```bash
# Deploy with default values
./easy-up.sh

# Deploy to a specific namespace
./easy-up.sh --namespace namespace

# Deploy with a custom release name
./easy-up.sh --release release-name

# Deploy to a specific environment
./easy-up.sh --env production
```

## Uninstallation

To remove the Wraft deployment:

```bash
# List all releases
helm list

# Uninstall the release
helm uninstall wraft
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading

To upgrade your Wraft deployment:

```bash
# Pull latest changes (if using git)
git pull

# Update dependencies
helm dependency build

# Upgrade the deployment
helm upgrade wraft .
```

For major version upgrades, please check the [Changelog](#changelog) for any breaking changes.

## Contributing

We welcome contributions to improve the Wraft Helm chart! Please read our [Contributing Guidelines](../../CONTRIBUTING.md) for details on:

- Code of Conduct
- Development Workflow
- Coding Standards
- Pull Request Process
- Documentation Requirements

We also maintain [Conventions](../../CONVENTIONS.md) for consistent chart development.

## Changelog

We maintain a changelog to document notable changes to the Wraft Helm chart. View the full changelog here: [CHANGELOG.md](../../CHANGELOG.md)

## License

This chart is licensed under the terms found in the [LICENSE](../../LICENSE) file at the root of this repository.
