# Contributing to Wraft Helm Chart

Thank you for your interest in contributing to the Wraft Helm chart! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)
- [Documentation](#documentation)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone. Please be considerate of differing viewpoints and experiences, and focus on what is best for the community.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/wraft-helm.git
   cd wraft-helm
   ```
3. **Add the upstream repository** as a remote:
   ```bash
   git remote add upstream https://github.com/wraft/wraft-helm.git
   ```
4. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

1. **Make your changes** following the [coding standards](#coding-standards)
2. **Test your changes** using the validation script:
   ```bash
   ./validate.sh
   ```
3. **Commit your changes** with a clear commit message:
   ```bash
   git commit -m "Add feature: description of your changes"
   ```
4. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
5. **Create a pull request** from your fork to the main repository

## Coding Standards

Please follow the conventions outlined in the [CONVENTIONS.md](CONVENTIONS.md) file, which includes:

### File Naming Conventions

- Use **kebab-case** for all file names (e.g., `network-policy.yaml`, `persistent-volume-claim.yaml`)
- Use **singular form** for resource types (e.g., `deployment.yaml` not `deployments.yaml`)
- Use **descriptive names** that indicate the resource type and purpose

### Directory Structure

Maintain the established directory structure:

```
wraft-helm/
├── templates/
│   ├── components/     # Application components
│   ├── config/         # Configuration resources
│   └── jobs/           # Job resources
└── environments/       # Environment-specific values
```

### YAML Style

- Use 2 spaces for indentation
- Add comments to explain complex logic
- Keep line length reasonable (preferably under 100 characters)
- Use consistent formatting for similar resources

### Helm Best Practices

- Use named templates for reusable components
- Leverage the `_helpers.tpl` file for common functions
- Follow Helm's best practices for template functions and conditionals
- Ensure all configurable values are exposed in `values.yaml` with appropriate defaults

## Pull Request Process

1. **Update documentation** to reflect any changes in functionality
2. **Ensure all tests pass** by running the validation script
3. **Update the CHANGELOG.md** with details of your changes
4. **Request a review** from at least one maintainer
5. **Address any feedback** provided during the review process
6. **Squash commits** if requested by the maintainers

## Release Process

Releases are managed by the maintainers. If you believe a new release is needed:

1. **Update the version** in Chart.yaml using the `update-version.sh` script:
   ```bash
   ./update-version.sh X.Y.Z
   ```
2. **Update the CHANGELOG.md** with all notable changes
3. **Create a pull request** with these changes
4. Once approved and merged, maintainers will **tag the release**

## Documentation

- **Update README.md** for user-facing changes
- **Update CONVENTIONS.md** for changes to coding standards
- **Update docs/** directory for template-specific documentation
- **Add comments** to complex templates explaining the logic

Thank you for contributing to the Wraft Helm chart! 