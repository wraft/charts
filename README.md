# Wraft Helm Chart

![Wraft Logo](https://via.placeholder.com/150?text=Wraft)

A Helm chart for deploying the Wraft application on Kubernetes clusters.

## 📋 Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Environment-Specific Configuration](#environment-specific-configuration)
- [Directory Structure](#directory-structure)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Upgrading](#upgrading)
- [Changelog](#changelog)
- [License](#license)
- [Contributing](#contributing)
- [Password Persistence](#password-persistence)

## 🚀 Quick Start

```bash
# Add the repository (if not using local chart)
# helm repo add wraft-repo https://your-repo-url.com

# Install with default values
helm install my-wraft ./wraft

# Verify the installation
kubectl get pods -l app.kubernetes.io/name=wraft
```

## ✅ Prerequisites

Before installing the chart, ensure you have:

- Kubernetes cluster (version 1.16+)
- Helm 3.0+ installed
- kubectl configured to communicate with your cluster
- PV provisioner support in your cluster (if persistence is enabled)

## 📦 Installation

### Basic Installation

```bash
# Clone this repository (if using local chart)
git clone https://github.com/your-org/wraft-helm.git
cd wraft-helm

# Install the chart
helm install my-wraft .
```

### Installation with Custom Values

```bash
# Using a custom values file
helm install my-wraft . -f my-values.yaml

# Or overriding specific values
helm install my-wraft . --set replicaCount=3 --set service.type=LoadBalancer
```

## ⚙️ Configuration

### Key Parameters

The following table lists the most common parameters you might want to configure:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas for the deployment | `1` |
| `image.repository` | Image repository | `wraft` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `resources.limits` | Resource limits | `{}` |
| `resources.requests` | Resource requests | `{}` |
| `persistence.enabled` | Enable persistent storage | `false` |
| `persistence.size` | Size of persistent volume | `10Gi` |

For a complete list of parameters, please refer to the [values.yaml](values.yaml) file.

### Customizing Values

There are several ways to customize the configuration values:

1. **Modifying the values.yaml file**:
   Edit the values.yaml file directly before installation:
   ```bash
   # Edit the values file
   nano values.yaml
   
   # Install with the modified values
   helm install my-wraft .
   ```

2. **Using a custom values file**:
   Create a separate values file with only the values you want to override:
   ```yaml
   # custom-values.yaml
   replicaCount: 2
   
   image:
     repository: my-registry/wraft
     tag: v1.2.3
   
   service:
     type: NodePort
   ```
   
   Then install or upgrade with:
   ```bash
   helm install my-wraft . -f custom-values.yaml
   # or
   helm upgrade my-wraft . -f custom-values.yaml
   ```

3. **Setting individual values via command line**:
   ```bash
   helm install my-wraft . --set key1=value1 --set key2=value2
   
   # For nested values use dot notation
   helm install my-wraft . --set image.repository=my-registry/wraft --set image.tag=v1.2.3
   
   # For arrays/lists
   helm install my-wraft . --set ingress.hosts[0].host=wraft.example.com
   ```

4. **Combining methods**:
   You can combine custom value files with command line overrides:
   ```bash
   helm install my-wraft . -f custom-values.yaml --set service.port=8080
   ```

### Value Precedence

When multiple value sources are provided, they are merged with the following precedence (highest to lowest):

1. Command line values (--set, --set-string, --set-file)
2. Values from value files (-f, --values)
3. Default values from the chart's values.yaml

### Checking Effective Configuration

To see the effective configuration that will be applied:

```bash
# Before installation
helm install my-wraft . --dry-run --debug

# For an existing release
helm get values my-wraft
```

## 📝 Examples

### Deploying with High Availability

```yaml
# ha-values.yaml
replicaCount: 3
resources:
  limits:
    cpu: 1
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

Apply with:
```bash
helm install ha-wraft . -f ha-values.yaml
```

### Exposing the Service

```yaml
# public-values.yaml
service:
  type: LoadBalancer
  port: 80
```

Apply with:
```bash
helm install public-wraft . -f public-values.yaml
```

## 🔍 Troubleshooting

### Common Issues

1. **Pods not starting**:
   ```bash
   kubectl describe pod -l app.kubernetes.io/name=wraft
   ```

2. **Service not accessible**:
   ```bash
   kubectl get svc -l app.kubernetes.io/name=wraft
   ```

3. **Resource constraints**:
   Check if your cluster has enough resources:
   ```bash
   kubectl describe nodes | grep -A 5 "Allocated resources"
   ```

## 🗑️ Uninstalling the Chart

To remove the Wraft deployment:

```bash
# List all releases
helm list

# Uninstall the release
helm uninstall my-wraft
```

This will remove all Kubernetes resources associated with the chart.

## 🔄 Upgrading

To upgrade your Wraft deployment:

```bash
# Update the repository (if not using local chart)
# helm repo update

# Upgrade the deployment
helm upgrade my-wraft .
```

For major version upgrades, please check the release notes for any breaking changes.

## 📝 Changelog

We maintain a changelog to document notable changes to the Wraft Helm chart. The changelog follows the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

View the full changelog here: [CHANGELOG.md](CHANGELOG.md)

## 📄 License

This chart is licensed under the terms found in the [LICENSE](LICENSE) file at the root of this repository.

## 👥 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

For bug reports or feature requests, please open an issue.

## Password Persistence

This Helm chart is configured to maintain consistent passwords and secrets across pod restarts and redeployments. This is achieved through:

1. **Deterministic Secret Generation**: Instead of using random generation for passwords, the chart uses a deterministic approach based on the Release name. This ensures that the same passwords are generated each time the chart is deployed with the same release name.

2. **Secret Retention Policy**: Secrets are annotated with `helm.sh/resource-policy: keep` to prevent Helm from deleting them during upgrades or redeployments.

3. **Versioned Jobs**: Jobs like the MinIO bucket creation job are versioned with the Release revision to ensure they run only when explicitly upgraded, not on pod restarts.

### Setting Explicit Passwords

For production environments, it's recommended to set explicit passwords in your values file or through Helm's `--set` flag:

```yaml
db:
  env:
    POSTGRES_PASSWORD: "your-secure-password"

minio:
  env:
    MINIO_ROOT_USER: "your-minio-admin"
    MINIO_ROOT_PASSWORD: "your-secure-minio-password"

typesense:
  env:
    TYPESENSE_API_KEY: "your-secure-typesense-key"

security:
  secretKeyBase: "your-secure-secret-key"
  guardianKey: "your-secure-guardian-key"
```

When explicit passwords are provided, they will be used instead of the generated ones and will persist across all deployments.

## Environment-Specific Configuration

This Helm chart supports environment-specific configurations through the use of environment-specific value files.

### Environment Value Files

The chart includes pre-configured environment value files for different deployment scenarios:

- `environments/dev/values.yaml`: Development environment configuration
- `environments/prod/values.yaml`: Production environment configuration

To use these environment-specific configurations:

```bash
# For development environment
helm install my-wraft . -f environments/dev/values.yaml

# For production environment
helm install my-wraft . -f environments/prod/values.yaml
```

### Domain Configuration

The chart uses the `global.domain` value to configure hostnames for ingress resources. For example, if `global.domain` is set to `example.com`, the following hostnames will be configured:

- Frontend: `app.example.com`
- Backend API: `api.example.com`
- MinIO Console: `minio.example.com`
- Typesense: `search.example.com`

### Database Configuration

Database credentials and connection details can be configured in the environment-specific values files:

```yaml
db:
  env:
    POSTGRES_USER: "wraft_prod"
    POSTGRES_PASSWORD: "secure_password"
    POSTGRES_DB: "wraft_production"
```

### Sensitive Information

For sensitive information like passwords and API keys, it's recommended to:

1. **Never commit secrets to version control**
2. **Use Kubernetes Secrets or external secret management solutions**
3. **Pass sensitive values via the command line**:

```bash
helm install my-wraft . -f environments/prod/values.yaml \
  --set db.env.POSTGRES_PASSWORD=secure_password \
  --set minio.env.MINIO_ROOT_PASSWORD=secure_minio_password \
  --set typesense.env.TYPESENSE_API_KEY=secure_typesense_key
```

## 📁 Directory Structure

The chart follows a well-organized structure for better maintainability:

```
wraft-helm/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default configuration values
├── templates/              # Template files
│   ├── NOTES.txt           # Installation notes
│   ├── _helpers.tpl        # Helper functions
│   ├── components/         # Application components
│   │   ├── deployment.yaml # Deployments
│   │   ├── service.yaml    # Services
│   │   └── ingress.yaml    # Ingress resources
│   ├── config/             # Configuration resources
│   │   ├── network-policy.yaml        # Network policies
│   │   ├── persistent-volume-claim.yaml # PVCs
│   │   ├── secret.yaml                # Secrets
│   │   └── serviceaccount.yaml        # Service accounts
│   └── jobs/               # Job resources
│       └── create-bucket-job.yaml     # Bucket creation job
└── environments/           # Environment-specific values
    ├── dev/                # Development environment
    └── prod/               # Production environment
```

This structure ensures:
- Clear separation of concerns
- Improved maintainability
- Easier navigation and understanding of the chart
