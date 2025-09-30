#!/bin/bash

# Deploy to Azure VM
# Usage: ./deploy_azure.sh <vm_ip> <storage_account> <ssh_key>

set -e

VM_IP=$1
STORAGE_ACCOUNT=$2
SSH_KEY=$3

if [ -z "$VM_IP" ] || [ -z "$STORAGE_ACCOUNT" ] || [ -z "$SSH_KEY" ]; then
  echo "Usage: $0 <vm_ip> <storage_account> <ssh_key>"
  exit 1
fi

IMAGE_URI="${AZURE_REGISTRY}.azurecr.io/multi-cloud-app:latest"

echo "Deploying to AKS cluster..."
# Get credentials
az aks get-credentials --resource-group multi-cloud-rg --name multi-cloud-cluster

# Install/upgrade Helm chart
helm upgrade --install multi-cloud-app ./helm \
  --set image.repository=$IMAGE_URI \
  --set cloudProvider=Azure \
  --wait

# Get service external IP
EXTERNAL_IP=$(kubectl get svc multi-cloud-app-multi-cloud-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Deployment to Azure AKS completed. External IP: $EXTERNAL_IP"

echo "Azure deployment successful."