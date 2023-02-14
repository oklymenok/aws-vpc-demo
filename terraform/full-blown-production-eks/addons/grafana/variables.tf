variable "grafana_namespace" {
  description = "Kubernetes namespace to deploy Grafana"
  type        = string
  default     = "monitoring"
}

# variable "grafana_admin_password" {
#   description = "Grafana web UI admin password"
#   type        = string
# }