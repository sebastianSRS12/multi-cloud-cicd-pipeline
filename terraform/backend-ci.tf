# Local backend configuration for CI/CD testing
# Rename this to backend.tf when running in CI/CD without AWS credentials

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}