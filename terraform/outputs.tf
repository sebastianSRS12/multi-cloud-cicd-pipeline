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