#!/bin/bash

# Script to set environment variables from Terraform outputs

cd terraform

export AWS_IP=$(terraform output -raw aws_instance_public_ip)
export AWS_BUCKET=$(terraform output -raw aws_bucket_name)
export AZURE_IP=$(terraform output -raw azure_vm_public_ip)
export AZURE_STORAGE=$(terraform output -raw azure_storage_account_name)

# SSH_KEY should be set manually or from var
# export SSH_KEY=your-key-path

echo "Environment variables set:"
echo "AWS_IP=$AWS_IP"
echo "AWS_BUCKET=$AWS_BUCKET"
echo "AZURE_IP=$AZURE_IP"
echo "AZURE_STORAGE=$AZURE_STORAGE"