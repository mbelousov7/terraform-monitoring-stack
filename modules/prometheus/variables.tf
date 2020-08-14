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

variable "container_name" {
  type        = string
}

variable "configPath" {
  type        = string
  default     = "/etc/prometheus"
}

variable "dataPath" {
  type        = string
  default     = "/data/"
}

variable "retentionTime" {
  type        = string
  default     = "7d"
}

variable "retentionSize" {
  type        = string
  default     = "30GB"
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

variable "configMap_file_sd_config_volumes" {
  description = "list config maps and volumes"
  type = list(object({
    mount_path = string
    name = string
    config_map_name = string
    config_map_data = map(string)
  }))
  default = [
    {
      mount_path = "/etc/prometheus/file_sd_config"
      name = "config-filesd-volume"
      config_map_name = "config-filesd"
      config_map_data = {}
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
