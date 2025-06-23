# Changelog

All notable changes to the Wraft Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2023-03-10

### Added
- Added CONTRIBUTING.md with comprehensive guidelines for contributors
- Added documentation for template directories in docs/templates/

### Changed
- Updated README.md to reference the new CONTRIBUTING.md file
- Improved validation script to work without requiring a Kubernetes cluster

## [0.1.1] - 2023-03-10

### Added
- Added CONVENTIONS.md to document file naming and organization standards
- Added validation script (validate.sh) for chart verification
- Added version update script (update-version.sh) for easier maintenance
- Added README files in template subdirectories for better documentation

### Changed
- Improved directory structure with dedicated folders for components, config, and jobs
- Standardized file naming conventions to use kebab-case and singular form
- Updated Chart.yaml with improved metadata
- Enhanced README.md with directory structure documentation

### Fixed
- Standardized inconsistent file naming patterns

## [Unreleased]

### Added
- Initial release of the Wraft Helm chart
- Support for deploying the complete Wraft stack:
  - Frontend application
  - Backend API service
  - PostgreSQL database
  - MinIO object storage
  - Typesense search service
- Configurable ingress with support for multiple hosts
- Security configurations including pod security contexts
- Resource allocation management
- Health probes for all services
- Support for persistence across components

### Changed

### Deprecated

### Removed

### Fixed

### Security 