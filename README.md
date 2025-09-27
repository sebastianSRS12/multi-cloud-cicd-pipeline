# Multi-Cloud CI/CD Pipeline

A standout project demonstrating a complete CI/CD pipeline that builds and deploys a Flask web application to AWS, GCP, and Azure using Terraform for infrastructure provisioning and scripts for automation.

## Architecture

```
Git Repo
    |
    v
Build (Bash) -> Test -> Package
    |
    v
Deploy Parallel
   /    |    \
  /     |     \
AWS   GCP   Azure
EC2   VM    VM
(S3) (GCS) (Storage)
```

- **Application**: Simple Flask app with health check endpoint.
- **Infrastructure**: Terraform modules for AWS (VPC, EC2, S3), GCP (VPC, VM, GCS), and Azure (VNet, VM, Storage).
- **CI/CD**: Scripts for build, deploy, and orchestration with parallel deployments and health checks.

## Features

- Multi-cloud deployment (AWS + GCP + Azure)
- Parallel deployments for speed
- Health checks post-deployment
- Modular Terraform configurations
- Automated build and test

## 🔒 Security Features Implemented

### Phase 1: Foundation Security (✅ Complete)
- **Remote State Management**: S3 backend with encryption and DynamoDB locking
- **Secrets Protection**: Sensitive variable flags prevent credential exposure
- **Policy as Code**: Sentinel policies enforce S3 encryption and instance type restrictions
- **Bootstrap Infrastructure**: Automated creation of secure state storage

### Phase 2: Secrets Management (✅ Complete)
- **Ephemeral Secrets**: Random password generation for databases and applications
- **AWS Secrets Manager**: Secure storage and retrieval of persistent secrets
- **Sensitive Outputs**: Protected Terraform outputs prevent credential leakage
- **Secret Rotation**: Automated secret lifecycle management

### Infrastructure Security
- **Multi-Cloud Support**: Complete AWS, GCP, and Azure infrastructure modules
- **Access Control**: NSG/firewall rules restrict network access
- **State Encryption**: All Terraform state encrypted at rest
- **Dependency Locking**: Provider versions locked for reproducible builds

### CI/CD Security
- **Automated Validation**: Terraform format, validate, and security scans
- **Policy Enforcement**: Sentinel policies prevent misconfigurations
- **Secure Deployments**: Parallel multi-cloud deployments with health checks

*Recent Update: Complete Azure infrastructure and unified pipeline support added.*

*Test CI/CD: Verifying automated security checks and validation.*

## Prerequisites

- AWS CLI configured
- GCP CLI configured and authenticated
- Azure CLI logged in
- Terraform installed
- SSH key pair
- Python 3, pip, git

## Setup

1. Clone the repo and navigate to the project:
   ```bash
   cd multi-cloud-cicd-pipeline
   ```

2. Configure Terraform variables:
   ```bash
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   # Edit terraform.tfvars with your values (AWS, GCP, Azure credentials)
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

- Access the app at `http://<AWS_IP>:5000`, `http://<GCP_IP>:5000`, and `http://<AZURE_IP>:5000`
- Health check: `http://<IP>:5000/health`

## Scripts

- `build.sh`: Install deps, run tests, package app
- `deploy_aws.sh`: Deploy to AWS EC2 via S3
- `deploy_gcp.sh`: Deploy to GCP VM via GCS
- `deploy_azure.sh`: Deploy to Azure VM via Storage
- `cicd_pipeline.sh`: Orchestrates the full pipeline with parallel deployments to AWS, GCP, and Azure

## Cleanup

```bash
cd terraform
terraform destroy
```

## Standout Elements

- Simultaneous multi-cloud deployments across three major providers
- Automated health verification
- Modular and reusable Terraform code
- Complete automation with Bash and PowerShell scripting