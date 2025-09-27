module "aws_infra" {
  source = "./modules/aws"

  region      = var.aws_region
  key_name    = var.aws_key_name
  bucket_name = var.aws_bucket_name
}

module "gcp_infra" {
  source = "./modules/gcp"

  project    = var.gcp_project
  bucket_name = var.gcp_bucket_name
}

module "azure_infra" {
  source = "./modules/azure"

  subscription_id   = var.azure_subscription_id
  location          = var.azure_location
  storage_account_name = var.azure_storage_account_name
  ssh_public_key    = var.azure_ssh_public_key
}