variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_key_name" {
  description = "AWS SSH key pair name"
  type        = string
}

variable "aws_bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "CIDR block for AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_public_subnets" {
  description = "List of public subnets CIDR blocks for AWS VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "aws_private_subnets" {
  description = "List of private subnets CIDR blocks for AWS VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_azs" {
  description = "List of availability zones for AWS VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_bucket_name" {
  description = "GCP storage bucket name"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
}

variable "azure_ssh_public_key" {
  description = "SSH public key for Azure VM access"
  type        = string
  sensitive   = true
}
