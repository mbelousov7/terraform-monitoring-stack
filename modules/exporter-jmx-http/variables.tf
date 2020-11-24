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
  default     = "RollingUpdate"
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

variable "container_resources_limits_cpu" {
  type        = string
  default     = "90m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "150Mi"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "250Mi"
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
  default     = 3
}


variable "service" {
  type        = bool
  default     = false
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
