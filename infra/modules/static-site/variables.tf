variable "domain_name" {
  description = "Apex domain name to serve (e.g. \"crosshairc2.com\"). The module also serves and issues a certificate for the \"www\" subdomain."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.domain_name))
    error_message = "domain_name must be a bare apex domain, e.g. \"crosshairc2.com\" (no scheme, no leading www.)."
  }
}

variable "hosted_zone_name" {
  description = "Name of the existing Route53 hosted zone to look up (usually the same as domain_name)."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. \"prod\"), used for tagging and resource naming."
  type        = string
}

variable "project" {
  description = "Project tag applied to all resources."
  type        = string
}

variable "team" {
  description = "Team tag applied to all resources."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class controlling edge location coverage."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "price_class must be one of PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "default_ttl" {
  description = "Default CloudFront cache TTL, in seconds, for objects without explicit cache-control headers."
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum CloudFront cache TTL, in seconds."
  type        = number
  default     = 86400
}

variable "min_ttl" {
  description = "Minimum CloudFront cache TTL, in seconds."
  type        = number
  default     = 0
}

variable "include_www" {
  description = "Whether to also serve and issue a certificate SAN for the www subdomain."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to merge onto every taggable resource."
  type        = map(string)
  default     = {}
}
