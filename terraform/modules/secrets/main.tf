terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "multi-cloud"
}

# Ephemeral secrets - generated on each apply
resource "random_password" "db_password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "random_password" "app_secret" {
  length  = 32
  special = true
  lower   = true
  upper   = true
  numeric = true
}

# AWS Secrets Manager for persistent secrets
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}-${var.environment}-db-credentials"
  description = "Database credentials for ${var.project_name} ${var.environment}"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
    database = "${var.project_name}_${var.environment}"
  })
}

resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "${var.project_name}-${var.environment}-app-secrets"
  description = "Application secrets for ${var.project_name} ${var.environment}"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    app_secret_key = random_password.app_secret.result
    jwt_secret     = random_password.app_secret.result
    api_key        = random_password.app_secret.result
  })
}

# Data sources for retrieving secrets
data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
}

data "aws_secretsmanager_secret_version" "app_secrets_data" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
}

# Outputs - mark sensitive ones
output "db_password" {
  description = "Generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "app_secret_key" {
  description = "Generated application secret key"
  value       = random_password.app_secret.result
  sensitive   = true
}

output "db_credentials_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "app_secrets_arn" {
  description = "ARN of the application secrets"
  value       = aws_secretsmanager_secret.app_secrets.arn
}

output "db_credentials_json" {
  description = "Database credentials as JSON (for reference)"
  value       = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
  sensitive   = true
}

output "app_secrets_json" {
  description = "Application secrets as JSON (for reference)"
  value       = jsondecode(data.aws_secretsmanager_secret_version.app_secrets_data.secret_string)
  sensitive   = true
}