resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = var.prometheus_namespace
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }
}