# Conditional backend: Use S3 for production, local for CI/CD testing
terraform {
  backend "s3" {
    bucket         = "multi-cloud-terraform-state"
    key            = "multi-cloud/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# For CI/CD environments without AWS credentials, use local backend
# Set TF_BACKEND=local in CI/CD environment variables
locals {
  backend_type = lookup({
    "local" = "local"
  }, var.backend_type, "s3")
}

# This would require moving backend configuration to main.tf with conditionals
# For now, CI/CD can override with: terraform init -backend-config="path=terraform.tfstate"