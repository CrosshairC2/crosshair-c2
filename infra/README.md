# Crosshair C2 — Infrastructure

Terraform for deploying the Angular marketing site (`../frontend`) to AWS as a static site at
`crosshairc2.com`.

## Architecture

```
S3 (private content bucket)
   -> CloudFront (OAC, HTTPS redirect, SPA fallback to index.html)
   -> ACM certificate (us-east-1, apex + www)
   -> Route53 (existing hosted zone, alias records for apex + www)
```

The S3 bucket has zero public access; CloudFront reaches it via Origin Access Control (OAC), and
the bucket policy is scoped to that one distribution's ARN. `www.crosshairc2.com` is served by the
same distribution as the apex domain (see `modules/static-site/README.md` for the reasoning).

## Layout

- `bootstrap/` — creates the Terraform remote-state S3 bucket. Stays on **local state
  permanently** (see "Remote state" below).
- `modules/static-site/` — the reusable module (S3 + CloudFront + ACM + Route53 records).
- `environments/prod/` — the only environment built so far. A future `environments/staging` would
  just be a copy of these five files with different `terraform.tfvars`.

## Remote state: bootstrap sequencing

`bootstrap/` deliberately never migrates to remote state — a backend that stores its own state
inside the resources it manages is a circular dependency, and a fresh clone of this repo has no
state backend to init against until bootstrap has run once.

1. `cd bootstrap`
2. `cp terraform.tfvars.example terraform.tfvars` and set a globally-unique `state_bucket_name`
   (S3 bucket names are global across all AWS accounts — `crosshair-c2-terraform-state` may already
   be taken; append your AWS account ID or similar if `apply` fails with a name conflict).
3. `terraform init` (local state — there's no backend block in this config)
4. `terraform apply`
5. Note the output: `terraform output state_bucket_name`. If you changed `state_bucket_name` from
   the default, update the literal value in `environments/prod/backend.tf` to match.
6. Back up the resulting local `bootstrap/terraform.tfstate` somewhere safe outside the repo (it's
   git-ignored). Losing it doesn't lose the AWS resources, but you'd need to re-import them to
   manage bootstrap with Terraform again.

Once bootstrap has run, `environments/prod/backend.tf` already points at the bucket it created, so
prod's first `terraform init` goes straight to the S3 backend — no `terraform init -migrate-state`
needed. (That flag would only come up if you'd applied prod locally *before* adding `backend.tf` —
not the normal flow here, but documented in case it happens.)

## Deploying the site

1. `cd environments/prod`, `cp terraform.tfvars.example terraform.tfvars` (defaults already match
   `crosshairc2.com` / `prod`), then `terraform init`, `terraform plan`, `terraform apply`.
2. Run `./deploy.sh` (from `environments/prod/`) to build the Angular app, sync it to the content
   bucket, and invalidate the CloudFront cache in one step. It requires `npm`, the AWS CLI with
   credentials that can write to the bucket and create invalidations, and that step 1 has already
   run (it reads the bucket name, distribution ID, and site URL from `terraform output`).
3. Verify: the script prints the site URL when it finishes — load it (and
   `https://www.crosshairc2.com`) in a browser and confirm HTTPS with a valid certificate.

`deploy.sh` runs these steps individually, for reference:
- Build: from `../../../frontend`, `npm run build` (production config), producing static assets in
  `frontend/dist/frontend/browser/`.
- Sync: `aws s3 sync frontend/dist/frontend/browser/ s3://<content_bucket_name>/ --delete`.
- Invalidate: `aws cloudfront create-invalidation --distribution-id <cloudfront_distribution_id>
  --paths "/*"`.

There's no CI/CD pipeline yet — `deploy.sh` is a manual process for now. A natural next step is a
GitHub Actions workflow that calls this same script on push to `main`, ideally using an
OIDC-federated deploy role scoped to this one bucket and distribution rather than long-lived
credentials.

## Security notes

- Both S3 buckets (content + Terraform state) block all public access, enable versioning, and use
  SSE-S3 encryption. State locking rides on the state bucket itself (native S3 lockfile locking),
  so there's no separate DynamoDB table to secure or pay for.
- No IAM roles/users are created in this pass — `terraform apply` and the manual deploy commands
  run under your own AWS CLI credentials. A dedicated least-privilege CI deploy role is future
  work, not built here.
- Every resource is tagged with `environment`, `team`, and `project`.
