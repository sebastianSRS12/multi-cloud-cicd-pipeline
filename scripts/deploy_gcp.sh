#!/bin/bash

# Deploy to GCP VM
# Usage: ./deploy_gcp.sh <vm_name> <zone> <bucket_name>

set -e

VM_NAME=$1
ZONE=$2
BUCKET_NAME=$3

if [ -z "$VM_NAME" ] || [ -z "$ZONE" ] || [ -z "$BUCKET_NAME" ]; then
  echo "Usage: $0 <vm_name> <zone> <bucket_name>"
  exit 1
fi

IMAGE_URI="gcr.io/${GCP_PROJECT_ID}/multi-cloud-app:latest"

echo "Deploying to GKE cluster..."
# Get credentials
gcloud container clusters get-credentials multi-cloud-cluster --zone=$ZONE --project=${GCP_PROJECT_ID}

# Install/upgrade Helm chart
helm upgrade --install multi-cloud-app ./helm \
  --set image.repository=$IMAGE_URI \
  --set cloudProvider=GCP \
  --wait

# Get service external IP
EXTERNAL_IP=$(kubectl get svc multi-cloud-app-multi-cloud-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Deployment to GCP GKE completed. External IP: $EXTERNAL_IP"

echo "GCP deployment successful."