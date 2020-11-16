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

variable "prometheus_container_image" {
  description = "image path"
  type        = string
}
variable "prometheus_container_port" {
  description = "prometheus port"
  type        = number
  default     = 9090
}

variable "pushgateway_container_image" {
  description = "image path"
  type        = string
}

variable "pushgateway_container_port" {
  description = "pushgateway port, DO NOT CHANGE"
  type        = number
  default     = 9091
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------------------------------------------

variable "monitoring_user" {
  description = "user for monitoring"
  type        = string
  default     = "prometheus"
}

variable "monitoring_password" {
  description = "password for monitoring_user"
  type        = string
}

variable "resolver" {
  type        = string
  description = "variable resolver for nginx"
  default     = "kube-dns.kube-system.svc.cluster.local"
}

variable "route_path_for_config" {
  type        = string
  description = "variable resolver for upstream in server.conf depends on instance of kubernetes cluster "
  default     = ".svc.cluster.local"
}
