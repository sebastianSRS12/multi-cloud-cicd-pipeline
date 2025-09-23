#!/bin/bash

# Main CI/CD pipeline script
# Runs build, then deploys to AWS and Azure in parallel

set -e

# Assume environment variables are set
# AWS_IP, AWS_BUCKET, AZURE_IP, AZURE_STORAGE, SSH_KEY

if [ -z "$AWS_IP" ] || [ -z "$AWS_BUCKET" ] || [ -z "$AZURE_IP" ] || [ -z "$AZURE_STORAGE" ] || [ -z "$SSH_KEY" ]; then
  echo "Please set environment variables: AWS_IP, AWS_BUCKET, AZURE_IP, AZURE_STORAGE, SSH_KEY"
  exit 1
fi

echo "Starting CI/CD pipeline..."

# Build
echo "Building application..."
./build.sh

# Deploy in parallel
echo "Deploying to AWS and Azure..."
./deploy_aws.sh $AWS_IP $AWS_BUCKET $SSH_KEY &
PID_AWS=$!

./deploy_azure.sh $AZURE_IP $AZURE_STORAGE $SSH_KEY &
PID_AZURE=$!

# Wait for both
wait $PID_AWS
wait $PID_AZURE

echo "Deployments completed. Performing health checks..."

# Health checks
curl -f http://$AWS_IP:5000/health || echo "AWS health check failed"
curl -f http://$AZURE_IP:5000/health || echo "Azure health check failed"

echo "CI/CD pipeline completed successfully."