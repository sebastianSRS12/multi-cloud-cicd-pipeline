# Conditional backend: Use S3 for production, local for CI/CD testing
terraform {
  backend "s3" {
    # These values can be overridden by -backend-config options in CI/CD
    # bucket, key, region, access_key, secret_key can be set dynamically
  }
}