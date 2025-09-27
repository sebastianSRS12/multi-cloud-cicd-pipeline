output "aws_instance_public_ip" {
  value = module.aws_infra.instance_public_ip
}

output "aws_bucket_name" {
  value = module.aws_infra.bucket_name
}

output "gcp_vm_public_ip" {
  value = module.gcp_infra.vm_public_ip
}

output "gcp_bucket_name" {
  value = module.gcp_infra.bucket_name
}

output "azure_vm_public_ip" {
  value = module.azure_infra.vm_public_ip
}

output "azure_storage_account_name" {
  value = module.azure_infra.storage_account_name
}

# Secrets outputs - marked as sensitive
output "db_password" {
  description = "Generated database password"
  value       = module.secrets.db_password
  sensitive   = true
}

output "app_secret_key" {
  description = "Generated application secret key"
  value       = module.secrets.app_secret_key
  sensitive   = true
}

output "db_credentials_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = module.secrets.db_credentials_secret_arn
}

output "app_secrets_arn" {
  description = "ARN of the application secrets"
  value       = module.secrets.app_secrets_arn
}