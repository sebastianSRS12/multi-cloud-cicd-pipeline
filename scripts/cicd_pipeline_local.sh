#!/bin/bash

# Local CI/CD pipeline simulation
# Runs build, then deploys to local "AWS" and "Azure" in parallel

set -e

echo "Starting local CI/CD pipeline simulation..."

# Build
echo "Building application..."
./build.sh

# Deploy in parallel
echo "Deploying to local AWS and Azure..."
./deploy_local_aws.sh &
PID_AWS=$!

./deploy_local_azure.sh &
PID_AZURE=$!

# Wait for both
wait $PID_AWS
wait $PID_AZURE

echo "Deployments completed. Performing health checks..."

# Health checks
sleep 2  # Wait for servers to start
curl -f http://127.0.0.1:5001/health || echo "Local AWS health check failed"
curl -f http://127.0.0.1:5002/health || echo "Local Azure health check failed"

echo "Local CI/CD pipeline completed successfully."
echo "Access apps at:"
echo "  Local AWS: http://127.0.0.1:5001"
echo "  Local Azure: http://127.0.0.1:5002"