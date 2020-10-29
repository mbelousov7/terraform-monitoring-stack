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

variable "monitoring_password" {
  description = "password for monitoring_user"
  type        = string
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = string
  default     = "8080"
}

variable "prometheus_port" {
  description = "prometheus_port"
  type        = string
  default     = "9090"
}

variable "pushgateway_port" {
  description = "pushgateway_port"
  type        = string
  default     = "9091"
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
