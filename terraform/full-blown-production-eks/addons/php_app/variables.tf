variable "namespace" {
  description = "Namespace to use for the deployment"
  type        = string
  default     = "default"
}

variable "create_lb" {
  description = "Wheter to create ELB for the app or not"
  type        = bool
  default     = false
}