terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# VPC (public + private subnets + NAT)


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "secops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.2.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project = "secops-test"
  }
}


# S3 bucket for security logs


resource "aws_s3_bucket" "logs" {
  bucket = "secops-logs-bucket-example" # must be globally unique

  tags = {
    Purpose = "SecurityLogs"
    Project = "secops-test"
  }
}


# GuardDuty enabled in the account


resource "aws_guardduty_detector" "main" {
  enable = true

  tags = {
    Project = "secops-test"
  }
}


# Basic WAF Web ACL with AWS managed rules


resource "aws_wafv2_web_acl" "basic" {
  name  = "secops-basic-waf"
  scope = "REGIONAL" # use CLOUDFRONT if attaching to CloudFront

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rules"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "secops-waf"
  }

  tags = {
    Project = "secops-test"
  }
}


# IAM Role for Service Accounts (IRSA placeholder)


resource "aws_iam_role" "eks_irsa" {
  name = "eks-irsa-secops"

  # NOTE: Replace ACCOUNT_ID and OIDC_PROVIDER in a real setup
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::123456789012:oidc-provider/eks-cluster-oidc"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # Example condition key – in a real cluster this would be:
            # "<OIDC_PROVIDER>:sub" = "system:serviceaccount:namespace:serviceaccount-name"
            "sts.amazonaws.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Project = "secops-test"
  }
}


output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "logs_bucket" {
  value = aws_s3_bucket.logs.bucket
}

output "waf_acl_arn" {
  value = aws_wafv2_web_acl.basic.arn
}
