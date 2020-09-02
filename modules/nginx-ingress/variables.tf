variable "namespace" {
  description = "namespace"
  type        = string
}

variable "app_name" {
  description = "app name"
  type        = string
  default     = "prometheus-app"
}

variable "labels" {
  description = "labels"
  type        = map(string)
  default     = {
  }
}

variable "replicas" {
  type        = string
  default     = 1
}

variable "strategy" {
  type        = string
  default     = "Recreate"
}


variable "container_image" {
  type        = string
}

variable "container_port" {
  type        = string
  default     = 8080
}

variable "container_name" {
  type        = string
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "0.05"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "0.05"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "0.1"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "0.1Gi"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "configMap_volumes" {
  description = "list config maps and volumes"
  type = list(object({
  mount_path = string
  name = string
  config_map_name = string
  config_map_data = map(string)
}))
# Default is being set in main.tf
default = [
  {
    mount_path = "/etc/prometheus"
    name = "config-main-volume"
    config_map_name = "prometheus-config-main"
    config_map_data = {}
  }
]
}

variable "server_list" {
  description = "server config list"
}

variable "auth_type" {
  type        = string
  description = "access to location auth type can be one of [none|basic|ldap]"
  default     = "basic"
}

variable "resolver" {
  type        = string
  description = "variable resolver for nginx"
  default     = "kube-dns.kube-system.svc.cluster.local"
}

variable "user" {
  description = "user"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "encrypted password"
  type        = string
  default     = "$apr1$Zd4voubY$3fMVQZZuDbMIKSeCdPS2y."
}
