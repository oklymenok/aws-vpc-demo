variable "kubernetes_version" {
  description = "EKS cluster Kubernetes version"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes Cluster Name"
  type        = string
}

variable "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
}

variable "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading https://)"
  type        = string
}

# Cluster Autoscaler variables
variable "enable_ca" {
  description = "Enable Cluster Autoscaler addon"
  type        = bool
  default     = false
}

variable "ca_namespace" {
  description = "Cluster Autoscaler deployment namespace"
  type        = string
  default     = "kube-system"
}

variable "ca_service_account" {
  description = "Cluster Autoscaler service account"
  type        = string
  default     = "cluster-autoscaler"
}

# Demo php app variables
variable "enable_php_app" {
  description = "Enable demo php app addon"
  type        = bool
  default     = false
}

# EBS CSI driver
variable "enable_ebs_csi" {
  description = "Enable EBS CSI driver"
  type        = bool
  default     = false
}

# Prometheus server
variable "enable_prometheus" {
  description = "Enable Prometheus"
  type        = bool
  default     = false
}

# Grafana Dashboard
variable "enable_grafana" {
  description = "Enable Grafana"
  type        = bool
  default     = false
}