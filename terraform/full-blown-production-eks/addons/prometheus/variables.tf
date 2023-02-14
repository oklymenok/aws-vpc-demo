variable "prometheus_namespace" {
    description = "Kubernetes namespace to deploy Prometheus"
    type        = string
    default     = "monitoring"
}