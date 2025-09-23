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
tar -czf ../artifacts/app.tar.gz --exclude='tests' --exclude='__pycache__' --exclude='*.pyc' .

echo "Build completed successfully. Artifact: artifacts/app.tar.gz"