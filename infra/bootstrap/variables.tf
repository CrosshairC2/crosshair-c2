variable "aws_region" {
  description = "AWS region for the Terraform state bucket."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the S3 bucket that stores Terraform remote state."
  type        = string
}

variable "project" {
  description = "Project tag applied to all resources."
  type        = string
  default     = "crosshair-c2"
}

variable "team" {
  description = "Team tag applied to all resources."
  type        = string
  default     = "engineering"
}
