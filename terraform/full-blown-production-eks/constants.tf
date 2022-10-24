locals {
  eks_cluster_name   = "simple-eks"
  kubernetes_version = "1.23"
  env                = "dev"
  ssh_key_name       = "default"
  region             = "us-east-1"

  # Addons
  enable_ca          = true # enable Cluster Auto Scaler
  ca_namespace       = "kube-system"
  ca_service_account = "cluster-autoscaler"

  enable_php_app     = true
}

data "aws_caller_identity" "current" {}