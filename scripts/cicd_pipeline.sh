#!/bin/bash

# Main CI/CD pipeline script
# Runs build, then deploys to AWS, GCP, and Azure in parallel

set -e

# Assume environment variables are set
# AWS_IP, AWS_BUCKET, GCP_VM_NAME, GCP_ZONE, GCP_BUCKET, GCP_IP, AZURE_IP, AZURE_STORAGE, SSH_KEY

if [ -z "$AWS_IP" ] || [ -z "$AWS_BUCKET" ] || [ -z "$GCP_VM_NAME" ] || [ -z "$GCP_ZONE" ] || [ -z "$GCP_BUCKET" ] || [ -z "$GCP_IP" ] || [ -z "$AZURE_IP" ] || [ -z "$AZURE_STORAGE" ] || [ -z "$SSH_KEY" ]; then
  echo "Please set environment variables: AWS_IP, AWS_BUCKET, GCP_VM_NAME, GCP_ZONE, GCP_BUCKET, GCP_IP, AZURE_IP, AZURE_STORAGE, SSH_KEY"
  exit 1
fi

echo "Starting CI/CD pipeline..."

# Build
echo "Building application..."
./build.sh

# Deploy in parallel
echo "Deploying to AWS, GCP, and Azure..."
./deploy_aws.sh $AWS_IP $AWS_BUCKET $SSH_KEY &
PID_AWS=$!

./deploy_gcp.sh $GCP_VM_NAME $GCP_ZONE $GCP_BUCKET &
PID_GCP=$!

./deploy_azure.sh $AZURE_IP $AZURE_STORAGE $SSH_KEY &
PID_AZURE=$!

# Wait for all
wait $PID_AWS
wait $PID_GCP
wait $PID_AZURE

echo "Deployments completed. Performing health checks..."

# Health checks
curl -f http://$AWS_IP:5000/health || echo "AWS health check failed"
curl -f http://$GCP_IP:5000/health || echo "GCP health check failed"
curl -f http://$AZURE_IP:5000/health || echo "Azure health check failed"

echo "CI/CD pipeline completed successfully."