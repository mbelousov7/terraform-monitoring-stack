variable "namespace" {
  description = "kubernetes namespace for prometheus"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "alertmanager"
}

variable "name_replica" {
  description = "second alertmanager peer name"
  type        = string
}

variable "labels" {
  description = "additional kubernetes labels, values provided from outside the module"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = number
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

variable "configPath" {
  description = "path to configs folder"
  type        = string
  default     = "/etc/alertmanager"
}

variable "dataPath" {
  description = "path to data folder"
  type        = string
  default     = "/data"
}

variable "retentionTime" {
  type        = string
  default     = "170h"
}

variable "container_port" {
  type        = number
  default     = 9093
}

variable "cluster_port" {
  type        = number
  default     = 9094
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "150m"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "200m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "200Mi"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "300Mi"
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
  default     = 2
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
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
    map_name = string
    map_path = string
    map_data = map(string)
  }))
  default = []
## Default is being set in main.tf
#default = [
#  {
#    map_path = "/etc/grafana"
#    map_name = "config-main-volume"
#    config_map_name = "grafana-config-main"
#    map_data = {}
#  }
#]
}

variable "secret_maps_list" {
  description = "list secret maps and volumes"
  type = list(object({
    map_name = string
    map_path = string
    map_data = map(string)
  }))
  default = []
}

variable "expose" {
  description = "expose resource type(ingress for kubernetes or route for openshift)"
  type        = string
  default     = "none"
}


variable "nginx_ingress_service_name" {
  description = "nginx_ingress_service_name"
  type        = string
  #default     = "nginx-ingress"
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = number
  default     = 8080
}
