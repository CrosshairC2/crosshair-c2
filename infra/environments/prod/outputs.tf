output "content_bucket_name" {
  description = "Name of the S3 bucket to sync the built site into."
  value       = module.static_site.content_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID, used for cache invalidation after deploys."
  value       = module.static_site.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront-assigned domain name for the distribution."
  value       = module.static_site.cloudfront_domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate."
  value       = module.static_site.acm_certificate_arn
}

output "site_url" {
  description = "Public HTTPS URL of the deployed site."
  value       = module.static_site.site_url
}
