#!/bin/bash

# Deploy to AWS EC2
# Usage: ./deploy_aws.sh <instance_ip> <bucket_name> <key_file>

set -e

INSTANCE_IP=$1
BUCKET_NAME=$2
KEY_FILE=$3

if [ -z "$INSTANCE_IP" ] || [ -z "$BUCKET_NAME" ] || [ -z "$KEY_FILE" ]; then
  echo "Usage: $0 <instance_ip> <bucket_name> <key_file>"
  exit 1
fi

IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/multi-cloud-app:latest"

echo "Deploying to EKS cluster..."
# Update kubeconfig
aws eks update-kubeconfig --region ${AWS_REGION} --name multi-cloud-cluster

# Install/upgrade Helm chart
helm upgrade --install multi-cloud-app ./helm \
  --set image.repository=$IMAGE_URI \
  --set cloudProvider=AWS \
  --wait

# Get service external IP
EXTERNAL_IP=$(kubectl get svc multi-cloud-app-multi-cloud-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [ -z "$EXTERNAL_IP" ]; then
  EXTERNAL_IP=$(kubectl get svc multi-cloud-app-multi-cloud-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
fi

echo "Deployment to AWS EKS completed. External IP: $EXTERNAL_IP"

echo "AWS deployment successful."