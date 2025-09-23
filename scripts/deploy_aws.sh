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

ARTIFACT="app.tar.gz"
LOCAL_ARTIFACT="../artifacts/$ARTIFACT"

echo "Uploading artifact to S3..."
aws s3 cp $LOCAL_ARTIFACT s3://$BUCKET_NAME/$ARTIFACT

echo "Deploying to EC2 instance..."
ssh -i $KEY_FILE -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP << EOF
  # Download artifact
  aws s3 cp s3://$BUCKET_NAME/$ARTIFACT /home/ec2-user/$ARTIFACT

  # Extract
  tar -xzf $ARTIFACT
  cd app

  # Install dependencies
  pip3 install -r requirements.txt

  # Kill existing app if running
  pkill -f "python3 app.py" || true

  # Run app
  export CLOUD_PROVIDER=AWS
  nohup python3 app.py > app.log 2>&1 &

  echo "Deployment to AWS completed."
EOF

echo "AWS deployment successful."