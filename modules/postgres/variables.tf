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

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}

variable "pod_management_policy" {
  type    = string
  default = "OrderedReady"
}

variable "update_strategy" {
  type    = string
  default = "RollingUpdate"
}

variable "container_port" {
  description = "postgres port, must not be changed"
  type        = number
  default     = 5432
}

variable "container_resources" {
  default = {
    requests_cpu    = "110m"
    limits_cpu      = "140m"
    requests_memory = "150Mi"
    limits_memory   = "180Mi"
  }
}

variable "container_args" {
  description = "additional container args"
  default     = []
}

variable "read_only_root_filesystem" {
  default = true
}



variable "readiness_probe" {
  default = {
    initial_delay_seconds = 15
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 10
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 60
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 10
  }
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "session_affinity" {
  type    = string
  default = "ClientIP"
}

variable "env_secret" {
  description = "main pod secret enviroment variables, values provided from outside the module"
  type        = map(any)
  default = {
    POSTGRES_USER     = "admin"
    POSTGRES_PASSWORD = "password"
    POSTGRES_DB       = "database"
  }
}
