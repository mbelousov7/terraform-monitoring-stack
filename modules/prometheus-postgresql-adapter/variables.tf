variable "namespace" {
  description = "kubernetes namespace for prometheus pushgateway"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "pushgateway"
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

variable "container_image" {
  description = "prometheus-postgresql-adapter image"
  type        = string
#  default     = ""
}

variable "strategy" {
  type        = string
  default     = "RollingUpdate"
}

variable "container_port" {
  description = "prometheus-postgresql-adapter port, must not be changed"
  type        = number
  default     = 9201
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "200m"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "300m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "300Mi"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "400Mi"
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

variable "liveness_probe_success_threshold" {
  type        = number
  default     = 1
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}
