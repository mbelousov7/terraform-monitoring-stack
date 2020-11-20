variable "namespace" {
  description = "kubernetes namespace for postgres"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "postgres"
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
  description = "postgres image"
  type        = string
#  default     = ""
}

variable "strategy" {
  type        = string
  default     = "Recreate"
}

variable "container_port" {
  description = "postgres port, must not be changed"
  type        = number
  default     = 5432
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "100m"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "150m"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "150Mi"
}
variable "container_resources_requests_memory" {
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
  default     = 2
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "env_secret" {
  description = "main pod secret enviroment variables, values provided from outside the module"
  type        = map
  default     = {
    POSTGRES_USER = "admin"
    POSTGRES_PASSWORD = "password"
    POSTGRES_DB = "database"
  }
}
