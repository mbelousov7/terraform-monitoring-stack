variable "namespace" {
  description = "kubernetes namespace for jmx-exporter"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "app(deployment) name"
  type        = string
  default     = "exporter-jmx"
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
  description = "path to jmx-exporter image"
  type        = string
}

variable "container_port" {
  type        = string
  default     = "5555"
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "50m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "128Mi"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "100m"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "254Mi"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

#exporter config variables

variable "config_maps_list" {
  description = "list config maps and volumes"
  type = list
  default = []
}

variable "system" {
  type        = string
}

variable "env" {
  description = "main pod enviroment variables, values provided from outside the module"
  type        = map
  default     = {}
}
