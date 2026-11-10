#!/usr/bin/env bash
# Builds the Angular site and deploys it to the prod S3 bucket + CloudFront
# distribution managed by this Terraform config (steps 2-4 of ../../README.md).
#
# Usage: ./deploy.sh
# Requires: terraform already applied in this directory, npm, and an AWS CLI
# profile with access to the content bucket and CloudFront distribution.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
frontend_dir="$script_dir/../../../frontend"
build_output="$frontend_dir/dist/frontend/browser"

echo "==> Building Angular app (production)"
(cd "$frontend_dir" && npm run build)

if [ ! -d "$build_output" ]; then
  echo "error: build output not found at $build_output" >&2
  exit 1
fi

echo "==> Reading Terraform outputs"
bucket_name=$(cd "$script_dir" && terraform output -raw content_bucket_name)
distribution_id=$(cd "$script_dir" && terraform output -raw cloudfront_distribution_id)
site_url=$(cd "$script_dir" && terraform output -raw site_url)

echo "==> Syncing $build_output to s3://$bucket_name/"
aws s3 sync "$build_output/" "s3://$bucket_name/" --delete

echo "==> Invalidating CloudFront distribution $distribution_id"
aws cloudfront create-invalidation --distribution-id "$distribution_id" --paths "/*" --query "Invalidation.Id" --output text

echo "==> Deployed. Site: $site_url"
