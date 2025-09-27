terraform {
  backend "s3" {
    bucket         = "multi-cloud-terraform-state"
    key            = "multi-cloud/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}