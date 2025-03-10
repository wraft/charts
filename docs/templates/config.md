# Configuration Directory

This directory contains configuration-related Kubernetes resources for the Wraft Helm chart.

## Files

- `network-policy.yaml`: Defines the Kubernetes NetworkPolicy resources for controlling pod communication
- `persistent-volume-claim.yaml`: Defines the Kubernetes PersistentVolumeClaim resources for storage
- `secret.yaml`: Defines the Kubernetes Secret resources for sensitive data
- `serviceaccount.yaml`: Defines the Kubernetes ServiceAccount resources for pod identity

## Usage

These templates are referenced by the main Helm chart and should not be installed individually. 