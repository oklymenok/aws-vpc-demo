locals {
  eks_cluster_name   = "simple-eks"
  kubernetes_version = "1.23"
  env                = "dev"
  ssh_key_name       = "default"
  region             = "us-east-1"

  # Cluster autoscaller addon
  enable_ca          = true
  ca_namespace       = "kube-system"
  ca_service_account = "cluster-autoscaler"

  # Simple test php application addon
  enable_php_app = false

  # EBS CSI driver addon. Required for persistent storage in EKS
  enable_ebs_csi = true

  # Collecting metrics
  enable_prometheus = true

  enable_grafana = true
}

data "aws_caller_identity" "current" {}
