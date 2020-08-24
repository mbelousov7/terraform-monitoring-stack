variable "namespace" {
  description = "kubernetes namespace for prometheus"
  type        = string
  default     = "monitoring"
}

variable "app_name" {
  description = "app(deployment) name"
  type        = string
  default     = "prometheus"
}

variable "labels" {
  description = "kubernetes labels"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = string
  default     = 1
}

variable "strategy" {
  type        = string
  default     = "Recreate"
}

variable "container_image" {
  description = "path to prometheus image"
  type        = string
}

variable "container_name" {
  description = "prometheus pod name"
  type        = string
}

variable "configPath" {
  description = "path to configs folder"
  type        = string
  default     = "/etc/prometheus"
}

variable "dataPath" {
  description = "path to data folder"
  type        = string
  default     = "/data"
}

variable "retentionTime" {
  type        = string
  default     = "7d"
}

variable "retentionSize" {
  type        = string
  default     = "30GB"
}

variable "container_port" {
  type        = string
  default     = "9090"
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "0.2"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "0.3Gi"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "0.3"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "0.5Gi"
}

variable "dataVolume" {
  default = {
    name = "storage-volume"
    empty_dir = {}
  }
}

variable "config_maps_list" {
  description = "list config maps and volumes"
  type = list(object({
  mount_path = string
  name = string
  config_map_name = string
  config_map_data = map(string)
}))
## Default is being set in main.tf
default = [
  {
    mount_path = "/etc/prometheus"
    name = "config-main-volume"
    config_map_name = "prometheus-config-main"
    config_map_data = {}
  }
]
}

variable "secret_maps_list" {
  description = "list secret maps and volumes"
  type = list(object({
  mount_path = string
  name = string
  secret_name = string
  secret_data = map(string)
}))
## Default is being set in main.tf
default = [
  {
    mount_path = "/etc/prometheus/secrets"
    name = "config-secret-volume"
    secret_name = "prometheus-secret"
    secret_data = {}
  }
]
}

variable "nginx_ingress_service_name" {
  description = "nginx_ingress_service_name"
  type        = string
  default     = "nginx-ingress"
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = string
  default     = 8080
}
