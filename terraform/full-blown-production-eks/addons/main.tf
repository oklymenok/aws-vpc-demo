module "cluster_autoscaler" {
  count             = var.enable_ca ? 1 : 0
  source            = "./cluster_autoscaler"
  oidc_provider     = var.oidc_provider
  oidc_provider_arn = var.oidc_provider_arn
}

module "php_app" {
  count     = var.enable_php_app ? 1 : 0
  source    = "./php_app"
  namespace = "php-apache"
  create_lb = true
}