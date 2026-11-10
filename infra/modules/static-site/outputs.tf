output "content_bucket_name" {
  description = "Name of the S3 bucket holding the built site assets."
  value       = aws_s3_bucket.content.id
}

output "content_bucket_arn" {
  description = "ARN of the S3 bucket holding the built site assets."
  value       = aws_s3_bucket.content.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution, used for cache invalidation."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront-assigned domain name (*.cloudfront.net) for the distribution."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate used by the distribution."
  value       = aws_acm_certificate_validation.site.certificate_arn
}

output "site_url" {
  description = "Public HTTPS URL of the site."
  value       = local.site_url
}
