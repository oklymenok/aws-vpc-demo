variable "autoscaler_namespace" {
  description = "Cluster Autoscaler deployment namespace"
  type = string
  default = "kube-system"
}

variable "autoscaler_service_account" {
  description = "Cluster Autoscaler service account"
  type = string
  default = "cluster-autoscaler"
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type = string
}

variable "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading https://)"
  type = string
}