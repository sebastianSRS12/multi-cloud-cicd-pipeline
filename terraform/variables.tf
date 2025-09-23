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

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_bucket_name" {
  description = "GCP storage bucket name"
  type        = string
}