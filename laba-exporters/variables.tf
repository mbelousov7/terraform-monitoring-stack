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

variable "namespace" {
  description = "kubernetes namespace"
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------------------------------------------

variable "monitoring_user" {
  description = "user for monitoring"
  type        = string
  default     = "prometheus"
}

variable "exporter_jmx_container_image" {
  description = "jmx exporter image path"
  type        = string
}


variable "monitoring_password" {
  description = "password for monitoring_user"
  type        = string
}
