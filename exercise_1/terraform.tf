terraform {

  backend "s3" { # Use S3 to persist state across GitHub Action runs
    bucket = "vprofileactions0811" # Ensure this bucket exists in S3
    key    = "terraform.tfstate" # State file path in the bucket
    region = "us-east-1" # Region for the S3 bucket
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
  }

  required_version = ">= 1.5.0"
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket        = "vprofileactions0811"
#   force_destroy = true
# }
