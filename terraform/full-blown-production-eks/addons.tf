module "cluster_autoscaler" {
  source            = "./addons/cluster_autoscaler"
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider
}