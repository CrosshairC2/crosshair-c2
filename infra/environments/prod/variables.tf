variable "aws_region" {
  description = "AWS region for non-global resources (e.g. the S3 content bucket)."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Apex domain name for the site."
  type        = string
  default     = "crosshairc2.com"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
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
