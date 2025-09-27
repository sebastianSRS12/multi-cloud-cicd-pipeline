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

# Least-privilege IAM policy for Terraform operations
resource "aws_iam_policy" "terraform_state_access" {
  name        = "${var.project_name}-${var.environment}-terraform-state-access"
  description = "Policy for Terraform to access state bucket and DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::multi-cloud-terraform-state",
          "arn:aws:s3:::multi-cloud-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/terraform-locks"
      }
    ]
  })
}

# Separate policies for plan vs apply (defense in depth)
resource "aws_iam_policy" "terraform_plan_only" {
  name        = "${var.project_name}-${var.environment}-terraform-plan"
  description = "Read-only policy for Terraform plan operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::multi-cloud-terraform-state",
          "arn:aws:s3:::multi-cloud-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/terraform-locks"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_apply_only" {
  name        = "${var.project_name}-${var.environment}-terraform-apply"
  description = "Write policy for Terraform apply operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::multi-cloud-terraform-state",
          "arn:aws:s3:::multi-cloud-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/terraform-locks"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Project": var.project_name
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          "arn:aws:s3:::multi-cloud-*",
          "arn:aws:s3:::multi-cloud-*/*"
        ]
      }
    ]
  })
}

# IAM user for CI/CD pipelines
resource "aws_iam_user" "terraform_ci" {
  name = "${var.project_name}-${var.environment}-terraform-ci"
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "CI/CD"
  }
}

resource "aws_iam_user_policy_attachment" "terraform_ci_plan" {
  user       = aws_iam_user.terraform_ci.name
  policy_arn = aws_iam_policy.terraform_plan_only.arn
}

# Separate user for apply operations
resource "aws_iam_user" "terraform_apply" {
  name = "${var.project_name}-${var.environment}-terraform-apply"
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "Apply"
  }
}

resource "aws_iam_user_policy_attachment" "terraform_apply_full" {
  user       = aws_iam_user.terraform_apply.name
  policy_arn = aws_iam_policy.terraform_apply_only.arn
}

# Outputs
output "terraform_ci_user_arn" {
  description = "ARN of the CI user for plan operations"
  value       = aws_iam_user.terraform_ci.arn
}

output "terraform_apply_user_arn" {
  description = "ARN of the apply user for deployment operations"
  value       = aws_iam_user.terraform_apply.arn
}

output "terraform_state_policy_arn" {
  description = "ARN of the Terraform state access policy"
  value       = aws_iam_policy.terraform_state_access.arn
}

output "terraform_plan_policy_arn" {
  description = "ARN of the Terraform plan-only policy"
  value       = aws_iam_policy.terraform_plan_only.arn
}

output "terraform_apply_policy_arn" {
  description = "ARN of the Terraform apply-only policy"
  value       = aws_iam_policy.terraform_apply_only.arn
}