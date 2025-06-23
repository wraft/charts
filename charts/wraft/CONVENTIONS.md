# Wraft Helm Chart Conventions

This document outlines the conventions used in the Wraft Helm chart to ensure consistency and maintainability.

## Directory Structure

The chart follows a structured organization:

```
wraft-helm/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default configuration values
├── templates/              # Template files
│   ├── NOTES.txt           # Installation notes
│   ├── _helpers.tpl        # Helper functions
│   ├── components/         # Application components
│   ├── config/             # Configuration resources
│   └── jobs/               # Job resources
└── environments/           # Environment-specific values
    ├── dev/                # Development environment
    └── prod/               # Production environment
```

## File Naming Conventions

### General Rules

1. Use **kebab-case** for all file names (e.g., `network-policy.yaml`, `persistent-volume-claim.yaml`)
2. Use **singular form** for resource types (e.g., `deployment.yaml` not `deployments.yaml`)
3. Use **descriptive names** that indicate the resource type and purpose

### Template Files

- **Components**: Files in the `components/` directory should be named after the Kubernetes resource type they contain:
  - `deployment.yaml`: Contains Deployment resources
  - `service.yaml`: Contains Service resources
  - `ingress.yaml`: Contains Ingress resources

- **Configuration**: Files in the `config/` directory should be named after the Kubernetes resource type they contain:
  - `network-policy.yaml`: Contains NetworkPolicy resources
  - `persistent-volume-claim.yaml`: Contains PersistentVolumeClaim resources
  - `secret.yaml`: Contains Secret resources
  - `serviceaccount.yaml`: Contains ServiceAccount resources

- **Jobs**: Files in the `jobs/` directory should be named descriptively with the job purpose:
  - `create-bucket-job.yaml`: Job for creating storage buckets

### Helper Files

- `_helpers.tpl`: Contains reusable template functions (note the leading underscore)
- `NOTES.txt`: Contains installation notes displayed after chart installation

## Coding Style

1. **Indentation**: Use 2 spaces for indentation in YAML files
2. **Comments**: Add comments to explain complex logic or configuration options
3. **Template Functions**: Use consistent naming for template functions:
   - `wraft.fullname`: For generating the full name of resources
   - `wraft.labels`: For generating common labels
   - `wraft.selectorLabels`: For generating selector labels

## Values Organization

1. **Global Values**: Place common configuration in the `global` section
2. **Component-Specific Values**: Group values by component
3. **Environment-Specific Values**: Place environment-specific overrides in the `environments/` directory

## Maintenance

1. **Version Updates**: Use the `update-version.sh` script to update the chart version
2. **Validation**: Use the `validate.sh` script to validate the chart before release
3. **Documentation**: Update README.md and CHANGELOG.md with each release 