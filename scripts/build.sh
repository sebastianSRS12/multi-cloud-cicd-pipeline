#!/bin/bash

# Build script for the Flask app
# Install dependencies, run tests, package the app

set -e  # Exit on error

echo "Starting build process..."

# Navigate to app directory
cd ../app

# Install dependencies
echo "Installing dependencies..."
pip3 install -r requirements.txt

# Run tests
echo "Running tests..."
python3 -m pytest tests/ -v

# Create artifacts directory if not exists
mkdir -p ../artifacts

# Package the app (exclude tests and __pycache__)
echo "Packaging app..."
tar -czf ../artifacts/app.tar.gz --exclude='tests' --exclude='__pycache__' --exclude='*.pyc' --exclude='Dockerfile' .

# Build Docker image
echo "Building Docker image..."
docker build -t multi-cloud-app:latest .

# Tag for registries (assume env vars set: AWS_ACCOUNT_ID, AWS_REGION, GCP_PROJECT_ID, AZURE_REGISTRY)
docker tag multi-cloud-app:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/multi-cloud-app:latest
docker tag multi-cloud-app:latest gcr.io/${GCP_PROJECT_ID}/multi-cloud-app:latest
docker tag multi-cloud-app:latest ${AZURE_REGISTRY}.azurecr.io/multi-cloud-app:latest

# Login and push images
echo "Pushing to AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/multi-cloud-app:latest

echo "Pushing to GCP GCR..."
gcloud auth configure-docker
docker push gcr.io/${GCP_PROJECT_ID}/multi-cloud-app:latest

echo "Pushing to Azure ACR..."
az acr login --name ${AZURE_REGISTRY}
docker push ${AZURE_REGISTRY}.azurecr.io/multi-cloud-app:latest

echo "Build completed successfully. Artifact: artifacts/app.tar.gz and Docker images pushed."