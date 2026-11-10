terraform {
  # >= 1.10 is required for the S3 backend's native `use_lockfile` locking
  # (see backend.tf) — no DynamoDB lock table needed.
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudFront requires its ACM certificate to live in us-east-1 regardless of
# the project's home region. Declared here even though aws_region already
# defaults to us-east-1, so the module stays region-agnostic.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
