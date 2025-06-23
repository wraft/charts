# Wraft Helm Chart

<div align="center">
  <p><strong>A Helm chart for deploying the Wraft application on Kubernetes clusters</strong></p>
</div>

## 📋 Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Environment-Specific Configuration](#environment-specific-configuration)
- [Directory Structure](#directory-structure)
- [Examples](#examples)
- [Password Persistence](#password-persistence)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Upgrading](#upgrading)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

## 📜 Overview

The Wraft Helm chart provides a complete solution for deploying the Wraft application stack on Kubernetes. It includes configurations for all necessary components:

- **Frontend**: Web interface for user interaction
- **Backend API**: RESTful services backend
- **Database**: PostgreSQL for data persistence
- **Search**: Typesense for fast, typo-tolerant search functionality
- **Object Storage**: MinIO for scalable, S3-compatible storage
- **Networking**: Ingress configurations for external access

This chart emphasizes security, scalability, and ease of maintenance across different environments.

## 🚀 Quick Start

Use our `easy-up.sh` script for a simple deployment:

```bash
./easy-up.sh
```

This will deploy Wraft with default settings to your Kubernetes cluster.

### Script Options

| Option | Description | Default |
|--------|-------------|---------|
| `-n, --namespace` | Kubernetes namespace | `default` |
| `-r, --release` | Helm release name | `wraft` |
| `-e, --env` | Environment configuration | `dev` |
| `-h, --help` | Show help message | - |

### Examples

```bash
# Deploy with default values
./easy-up.sh

# Deploy to a specific namespace
./easy-up.sh --namespace my-namespace

# Deploy with a custom release name
./easy-up.sh --release my-release-name

# Deploy to a specific environment
./easy-up.sh --env production
```

## ✅ Prerequisites

- Kubernetes cluster (version 1.16+)
- Helm 3.0+ installed
- kubectl configured to communicate with your cluster
- PV provisioner support in your cluster (if persistence is enabled)
- Sufficient cluster resources for all components:
  - At least 2 vCPUs and 4GB RAM recommended
  - Minimum 20GB storage for persistent volumes

## 📦 Installation

### Using the easy-up.sh Script

The quickest way to install Wraft is using our easy-up.sh script as mentioned in the [Quick Start](#quick-start) section.

### Manual Installation

If you prefer more control, you can perform a manual installation:

```bash
# Clone this repository
git clone https://github.com/wraft/wraft-helm.git
cd wraft-helm

# Build the dependencies
helm dependency build

# Install the chart with the release name "wraft"
helm upgrade --install wraft . --values values.yaml --values environments/dev/values.yaml
```

### Installation with Custom Values

```bash
# Using a custom values file
helm install my-wraft . -f my-values.yaml

# Or overriding specific values
helm install my-wraft . --set replicaCount=3 --set service.type=LoadBalancer
```

### Post-Installation Setup

#### Port-Forward Backend Pod
```bash
# Allow the frontend to connect to the backend service
kubectl port-forward pod/$(kubectl get pods -l app=wraft-backend -o jsonpath="{.items[0].metadata.name}") 4000:4000
```

#### Update /etc/hosts
```bash
# Add your node IP and ingress hostname to ensure MinIO functions correctly
echo "$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')  minio-api.local" | sudo tee -a /etc/hosts
```

## ⚙️ Configuration

### Key Parameters

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
| `global.domain` | Base domain for all services | `example.com` |

For a complete list of parameters, please refer to the [values.yaml](values.yaml) file.

### Customizing Values

There are several ways to customize the configuration:

#### 1. Modifying the values.yaml file

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

### Checking Effective Configuration

```bash
# Before installation
helm install my-wraft . --dry-run --debug

# For an existing release
helm get values my-wraft
```

## 🌍 Environment-Specific Configuration

This chart supports environment-specific configurations through dedicated value files.

### Environment Value Files

The chart includes pre-configured environment files:

- `environments/dev/values.yaml`: Development environment (lower resource requirements, debugging enabled)
- `environments/prod/values.yaml`: Production environment (optimized for performance and reliability)

To use these configurations:

```bash
# For development environment
helm install my-wraft . -f environments/dev/values.yaml

# For production environment
helm install my-wraft . -f environments/prod/values.yaml
```

### Domain Configuration

The chart uses the `global.domain` value to configure hostnames:

| Service | Hostname Pattern |
|---------|------------------|
| Frontend | `app.{global.domain}` |
| Backend API | `api.{global.domain}` |
| MinIO Console | `minio.{global.domain}` |
| Typesense | `search.{global.domain}` |

### Sensitive Information

For sensitive data like passwords and API keys:

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

## 🔐 Password Persistence

This chart maintains consistent passwords across deployments through:

1. **Deterministic Secret Generation**: Passwords are generated based on the release name, ensuring consistency.

2. **Secret Retention Policy**: Secrets are annotated with `helm.sh/resource-policy: keep` to prevent deletion during upgrades.

3. **Versioned Jobs**: Jobs are versioned with the release revision to run only when explicitly upgraded.

### Setting Explicit Passwords

For production, set explicit passwords in your values file:

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

## 🔍 Troubleshooting

### Common Issues and Solutions

#### 1. Pods not starting

**Symptoms**: Pods remain in `Pending` or `CrashLoopBackOff` state.

**Diagnosis**:
```bash
kubectl describe pod -l app.kubernetes.io/name=wraft
```

**Common causes and solutions**:
- **Resource constraints**: Ensure your cluster has sufficient resources
- **Configuration errors**: Check for typos in values or missing required fields
- **Image pull errors**: Verify image repository access and credentials

#### 2. Service not accessible

**Symptoms**: Unable to connect to services.

**Diagnosis**:
```bash
kubectl get svc -l app.kubernetes.io/name=wraft
kubectl get ingress
```

**Common causes and solutions**:
- **Service type**: Ensure service type matches your environment (ClusterIP, NodePort, LoadBalancer)
- **Ingress configuration**: Verify ingress controller is running and rules are correct
- **Network policies**: Check if network policies are blocking traffic

#### 3. Persistent volume issues

**Symptoms**: Storage-related errors.

**Diagnosis**:
```bash
kubectl get pv,pvc
kubectl describe pvc
```

**Solutions**:
- Ensure your cluster has a PV provisioner
- Check storage class availability and configuration
- Verify volume size and access modes

## 🗑️ Uninstallation

To remove the Wraft deployment:

```bash
# List all releases
helm list

# Uninstall the release
helm uninstall my-wraft
```

This will remove all Kubernetes resources associated with the chart. Note that PVCs and PVs might not be automatically deleted depending on your reclaim policy.

## 🔄 Upgrading

To upgrade your Wraft deployment:

```bash
# Pull latest changes (if using git)
git pull

# Update dependencies
helm dependency build

# Upgrade the deployment
helm upgrade my-wraft .
```

For major version upgrades, please check the [Changelog](#changelog) for any breaking changes.

## 👥 Contributing

We welcome contributions to improve the Wraft Helm chart! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code of Conduct
- Development Workflow
- Coding Standards
- Pull Request Process
- Documentation Requirements

We also maintain [Conventions](CONVENTIONS.md) for consistent chart development.

## 📝 Changelog

We maintain a changelog to document notable changes to the Wraft Helm chart. View the full changelog here: [CHANGELOG.md](CHANGELOG.md)

## 📄 License

This chart is licensed under the terms found in the [LICENSE](LICENSE) file at the root of this repository.
