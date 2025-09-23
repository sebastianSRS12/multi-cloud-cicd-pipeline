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

ARTIFACT="app.tar.gz"
LOCAL_ARTIFACT="../artifacts/$ARTIFACT"

echo "Uploading artifact to GCP Storage..."
gsutil cp $LOCAL_ARTIFACT gs://$BUCKET_NAME/$ARTIFACT

echo "Deploying to GCP VM..."
gcloud compute ssh $VM_NAME --zone=$ZONE --command="
  # Download artifact
  gsutil cp gs://$BUCKET_NAME/$ARTIFACT /home/ubuntu/$ARTIFACT

  # Extract
  tar -xzf $ARTIFACT
  cd app

  # Install dependencies
  pip3 install -r requirements.txt

  # Kill existing app if running
  pkill -f 'python3 app.py' || true

  # Run app
  export CLOUD_PROVIDER=GCP
  nohup python3 app.py > app.log 2>&1 &

  echo 'Deployment to GCP completed.'
"

echo "GCP deployment successful."