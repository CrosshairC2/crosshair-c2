# Values here must match the bootstrap config's outputs (infra/bootstrap).
# Terraform backend blocks cannot reference variables or data sources, so
# these are literal values populated after `terraform apply` in bootstrap/.
#
# Locking uses the S3 backend's native lockfile support (`use_lockfile`,
# Terraform >= 1.10) rather than a DynamoDB table: it takes a lock via a
# conditional write to a lockfile object in this same bucket, so no separate
# lock table needs to be created or maintained.
terraform {
  backend "s3" {
    bucket       = "crosshair-c2-terraform-state"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
