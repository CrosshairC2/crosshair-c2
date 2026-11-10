locals {
  common_tags = {
    environment = var.environment
    team        = var.team
    project     = var.project
  }
}

module "static_site" {
  source = "../../modules/static-site"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  domain_name      = var.domain_name
  hosted_zone_name = var.domain_name
  environment      = var.environment
  project          = var.project
  team             = var.team
  tags             = local.common_tags
}
