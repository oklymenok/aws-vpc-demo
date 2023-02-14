module "addons" {
  source             = "./addons"
  kubernetes_version = "1.23"
  cluster_name       = local.eks_cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider      = module.eks.oidc_provider
  # The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready
  cluster_id = module.eks.cluster_id

  # Enable autoscaler
  enable_ca          = local.enable_ca
  ca_namespace       = local.ca_namespace
  ca_service_account = local.ca_service_account

  # Enable demo php app
  enable_php_app = local.enable_php_app

  # Enable EBS CSI Driver
  enable_ebs_csi = local.enable_ebs_csi

  enable_prometheus = local.enable_prometheus
  enable_grafana    = local.enable_grafana
}