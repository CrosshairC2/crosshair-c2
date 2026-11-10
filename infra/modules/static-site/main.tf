locals {
  common_tags = merge(
    {
      environment = var.environment
      team        = var.team
      project     = var.project
    },
    var.tags,
  )

  www_domain_name  = "www.${var.domain_name}"
  all_domain_names = var.include_www ? [var.domain_name, local.www_domain_name] : [var.domain_name]

  site_url = "https://${var.domain_name}"
}
