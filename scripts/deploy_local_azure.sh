#!/bin/bash

# Simulate deploy to Azure locally
# Extract artifact and run app on port 5002

set -e

ARTIFACT="../artifacts/app.tar.gz"
LOCAL_DIR="../deploy/azure"

echo "Simulating Azure deployment locally..."

# Create deploy dir
mkdir -p $LOCAL_DIR

# Extract artifact
tar -xzf $ARTIFACT -C $LOCAL_DIR

# Change to app dir
cd $LOCAL_DIR/app

# Install dependencies (assume already done)
# pip3 install -r requirements.txt

# Kill existing app if running
pkill -f "python3 app.py.*5002" || true

# Run app
export CLOUD_PROVIDER=Azure
export FLASK_RUN_PORT=5002
export FLASK_RUN_HOST=0.0.0.0
nohup python3 app.py > app.log 2>&1 &

echo "Local Azure deployment completed. App running on port 5002."