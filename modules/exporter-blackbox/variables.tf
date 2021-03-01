variable "namespace" {
  description = "kubernetes namespace for jmx-exporter"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "exporter-blackbox"
}

variable "labels" {
  description = "additional kubernetes labels, values provided from outside the module"
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
  default     = "RollingUpdate" #"Recreate"
}

variable "image_pull_policy" {
  type        = string
  default     = "IfNotPresent" #"Always"
}

variable "container_image" {
  description = "path to jmx-exporter image"
  type        = string
}

variable "container_port" {
  type        = string
  default     = "9115"
}

variable "container_resources" {
  default = {
    requests_cpu = "0.05"
    limits_cpu ="0.05"
    requests_memory = "150M"
    limits_memory = "150M"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 30
    timeout_seconds = 55
    period_seconds = 120
    failure_threshold = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 15
    timeout_seconds = 55
    period_seconds = 60
    failure_threshold = 3
  }
}

variable "service" {
  type        = bool
  default     = false
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "session_affinity" {
  type        = string
  default     = "None"
  #default     = "ClientIP"
}
