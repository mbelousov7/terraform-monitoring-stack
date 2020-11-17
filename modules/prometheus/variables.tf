variable "namespace" {
  description = "kubernetes namespace for prometheus"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "prometheus"
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
  type        = number
  default     = 9090
}

/*
variable "liveness_probe" {
  default = {
    timeout_seconds = 300
    period_seconds = 300
    failure_threshold = 10
    http_get {
      path = "/targets"
      port = 9090
    }
  }
}
*/

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
  type = list
#  (object({
#  mount_path = string
#  name = string
#  config_map_name = string
#  config_map_data = map(string)
#}))
## Default is being set in main.tf
default = []
}

variable "secret_maps_list" {
  description = "list secret maps and volumes"
  type = list
  #(object({
  #mount_path = string
  #name = string
  #secret_name = string
  #secret_data = map(string)
#}))
## Default is being set in main.tf
default = []
}

variable "expose" {
  description = "expose resource type(ingress for kubernetes or route for openshift)"
  type        = string
  default     = "ingress"
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
