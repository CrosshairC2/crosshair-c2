# static-site

Serves a static single-page app from a private S3 bucket via CloudFront, with an ACM certificate
and Route53 alias records for an existing hosted zone.

Architecture: `S3 (private, OAC-only) -> CloudFront (HTTPS, SPA fallback to index.html) -> ACM cert
(us-east-1) -> Route53 alias records (apex + optional www)`.

## Usage

```hcl
module "static_site" {
  source = "../../modules/static-site"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  domain_name      = "crosshairc2.com"
  hosted_zone_name = "crosshairc2.com"
  environment      = "prod"
  project          = "crosshair-c2"
  team             = "engineering"

  tags = {
    managed_by = "terraform"
  }
}
```

## Inputs

| Name             | Type           | Default          | Required | Description                                                              |
| ---------------- | -------------- | ---------------- | -------- | ------------------------------------------------------------------------- |
| domain_name      | string         | -                | yes      | Apex domain to serve, e.g. `crosshairc2.com`.                             |
| hosted_zone_name | string         | -                | yes      | Existing Route53 hosted zone name to look up (not created by this module).|
| environment      | string         | -                | yes      | Environment name, used for tagging/naming.                                |
| project          | string         | -                | yes      | Project tag value.                                                        |
| team             | string         | -                | yes      | Team tag value.                                                           |
| price_class      | string         | `PriceClass_100` | no       | CloudFront edge coverage. See AWS docs for the full list.                 |
| default_ttl      | number         | `3600`           | no       | Default CloudFront cache TTL, seconds.                                    |
| max_ttl          | number         | `86400`          | no       | Maximum CloudFront cache TTL, seconds.                                    |
| min_ttl          | number         | `0`              | no       | Minimum CloudFront cache TTL, seconds.                                    |
| include_www      | bool           | `true`           | no       | Also serve/cert `www.<domain_name>`, aliased to the same distribution.    |
| tags             | map(string)    | `{}`             | no       | Extra tags merged onto every taggable resource.                           |

## Outputs

| Name                        | Description                                          |
| --------------------------- | ----------------------------------------------------- |
| content_bucket_name         | S3 bucket name holding the built site assets.         |
| content_bucket_arn          | S3 bucket ARN.                                        |
| cloudfront_distribution_id  | CloudFront distribution ID (for cache invalidation).  |
| cloudfront_distribution_arn | CloudFront distribution ARN.                          |
| cloudfront_domain_name      | The `*.cloudfront.net` domain name.                   |
| acm_certificate_arn         | ARN of the validated ACM certificate.                 |
| site_url                    | Public HTTPS URL of the site.                         |

## Design notes

- **Encryption is SSE-S3 (AES256), not SSE-KMS.** This bucket holds public static marketing
  content with no sensitive data and no compliance driver for customer-managed keys. SSE-KMS would
  add per-request cost and key-management overhead with no security benefit here — a deliberate
  choice, not an oversight.
- **Origin Access Control (OAC), not the deprecated Origin Access Identity (OAI).** The bucket
  policy grants `s3:GetObject` only to `cloudfront.amazonaws.com`, scoped via an `AWS:SourceArn`
  condition to this specific distribution — the bucket has zero public access on its own.
- **www and apex are served identically** by the same CloudFront distribution (the cert covers
  both as SANs). A `www` -> apex redirect via a CloudFront Function is a reasonable future
  enhancement but isn't built here to keep this first pass minimal; set `include_www = false` to
  drop www support entirely instead.
- **This module does not create the Route53 hosted zone** — it looks up an existing one via
  `data "aws_route53_zone"`. Point `hosted_zone_name` at a zone that already exists.
