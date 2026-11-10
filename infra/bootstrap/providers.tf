terraform {
  # Kept in sync with environments/prod, which requires >= 1.10 for the S3
  # backend's native `use_lockfile` locking.
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Intentionally no `backend` block: this configuration bootstraps the
  # remote state backend used by every other root config, so it must stay
  # on local state permanently to avoid a circular dependency.
}

provider "aws" {
  region = var.aws_region
}
