#!/bin/bash

# Simulate deploy to AWS locally
# Extract artifact and run app on port 5001

set -e

ARTIFACT="../artifacts/app.tar.gz"
LOCAL_DIR="../deploy/aws"

echo "Simulating AWS deployment locally..."

# Create deploy dir
mkdir -p $LOCAL_DIR

# Extract artifact
tar -xzf $ARTIFACT -C $LOCAL_DIR

# Change to app dir
cd $LOCAL_DIR/app

# Install dependencies (assume already done)
# pip3 install -r requirements.txt

# Kill existing app if running
pkill -f "python3 app.py.*5001" || true

# Run app
export CLOUD_PROVIDER=AWS
export FLASK_RUN_PORT=5001
export FLASK_RUN_HOST=0.0.0.0
nohup python3 app.py > app.log 2>&1 &

echo "Local AWS deployment completed. App running on port 5001."