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