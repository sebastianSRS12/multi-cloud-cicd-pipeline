# Multi-Cloud CI/CD Pipeline

A standout project demonstrating a complete CI/CD pipeline that builds and deploys a Flask web application to both AWS and Azure using Terraform for infrastructure provisioning and Bash scripts for automation.

## Architecture

```
Git Repo
    |
    v
Build (Bash) -> Test -> Package
    |
    v
Deploy Parallel
    /       \
   /         \
AWS EC2     Azure VM
(S3)        (Storage)
```

- **Application**: Simple Flask app with health check endpoint.
- **Infrastructure**: Terraform modules for AWS (VPC, EC2, S3) and Azure (VNet, VM, Storage).
- **CI/CD**: Bash scripts for build, deploy, and orchestration with parallel deployments and health checks.

## Features

- Multi-cloud deployment (AWS + Azure)
- Parallel deployments for speed
- Health checks post-deployment
- Modular Terraform configurations
- Automated build and test

## Prerequisites

- AWS CLI configured
- Azure CLI logged in
- Terraform installed
- SSH key pair
- Python 3, pip, git

## Setup

1. Clone the repo and navigate to the project:
   ```bash
   cd proyectos/multi-cloud-cicd
   ```

2. Configure Terraform variables:
   ```bash
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. Deploy infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

4. Set environment variables:
   ```bash
   source set_env.sh
   export SSH_KEY=path/to/your/private/key
   ```

5. Run the CI/CD pipeline:
   ```bash
   cd scripts
   ./cicd_pipeline.sh
   ```

## Usage

- Access the app at `http://<AWS_IP>:5000` and `http://<AZURE_IP>:5000`
- Health check: `http://<IP>:5000/health`

## Scripts

- `build.sh`: Install deps, run tests, package app
- `deploy_aws.sh`: Deploy to AWS EC2 via S3
- `deploy_azure.sh`: Deploy to Azure VM via Storage
- `cicd_pipeline.sh`: Orchestrates the full pipeline

## Cleanup

```bash
cd terraform
terraform destroy
```

## Standout Elements

- Simultaneous multi-cloud deployments
- Automated health verification
- Modular and reusable Terraform code
- Complete automation with Bash scripting