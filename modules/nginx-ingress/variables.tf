variable "namespace" {
  description = "namespace"
  type        = string
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "prometheus-app"
}

variable "labels" {
  description = "labels"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  type        = number
  default     = 1
}

variable "strategy" {
  type        = string
  default     = "RollingUpdate"
}


variable "container_image" {
  type        = string
}

variable "container_port" {
  type        = number
  default     = 8080
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "50m"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "90m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "160Mi"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "200Mi"
}


variable "liveness_probe_timeout_seconds" {
  type        = number
  default     = 30
}

variable "liveness_probe_period_seconds" {
  type        = number
  default     = 60
}

variable "liveness_probe_failure_threshold" {
  type        = number
  default     = 1
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

variable "route_path_for_config" {
  type        = string
  description = "variable resolver for upstream in server.conf depends on instance of kubernetes cluster "
  default     = ".svc.cluster.local"
}

variable "user" {
  description = "user"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "encrypted password"
  type        = string
  default     = "$apr1$Zd4voubY$3fMVQZZuDbMIKSeCdPS2y." //admin
}
