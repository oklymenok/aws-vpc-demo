resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = var.grafana_namespace
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  set {
    name  = "persistence.storageClassName"
    value = "gp2"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }
}