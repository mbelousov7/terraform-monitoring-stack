# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------

variable "kubernetes_host" {
  description = "kubernetes host:port address  "
  type        = string
}

variable "kubernetes_token" {
  description = "kubernetes token"
  type        = string
}

variable "kubernetes_namespace" {
  description = "kubernetes namespace"
  type        = string
}
