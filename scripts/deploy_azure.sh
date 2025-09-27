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

ARTIFACT="app.tar.gz"
LOCAL_ARTIFACT="../artifacts/$ARTIFACT"
CONTAINER_NAME="artifacts"

echo "Uploading artifact to Azure Storage..."
az storage blob upload --account-name $STORAGE_ACCOUNT --container-name $CONTAINER_NAME --name $ARTIFACT --file $LOCAL_ARTIFACT --auth-mode key

echo "Deploying to Azure VM..."
ssh -i $SSH_KEY -o StrictHostKeyChecking=no azureuser@$VM_IP << EOF
  # Download artifact
  az storage blob download --account-name $STORAGE_ACCOUNT --container-name $CONTAINER_NAME --name $ARTIFACT --file /home/azureuser/$ARTIFACT --auth-mode key

  # Extract
  tar -xzf $ARTIFACT
  cd app

  # Install dependencies
  pip3 install -r requirements.txt

  # Kill existing app if running
  pkill -f 'python3 app.py' || true

  # Run app
  export CLOUD_PROVIDER=Azure
  nohup python3 app.py > app.log 2>&1 &
EOF

echo "Azure deployment successful."