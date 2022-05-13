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

variable "strategy" {
  type    = string
  default = "RollingUpdate" #"Recreate"
}

variable "container_image" {
  description = "pushgateway image"
  type        = string
  #  default     = ""
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}

variable "container_port" {
  description = "pushgateway port, must not be changed"
  type        = number
  default     = 9091
}

variable "container_resources" {
  default = {
    requests_cpu    = "0.05"
    limits_cpu      = "0.05"
    requests_memory = "100M"
    limits_memory   = "110M"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 5
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 10
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 3
  }
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "expose" {
  description = "expose resource type(ingress for kubernetes or route for openshift)"
  type        = string
  default     = "none"
}

variable "route_suffix" {
  description = "route suffix"
  type        = string
  default     = "none"
}

variable "nginx_ingress_service_name" {
  description = "nginx_ingress_service_name"
  type        = string
  #default     = "nginx-ingress_pushgateway"
}

variable "nginx_ingress_port" {
  description = "nginx ingress port for application(not a application port)"
  type        = number
  default     = 8080
}

variable "pushgateway_cleaner_container_image" {
  description = "path to configmap-reloader image"
  type        = string
}

variable "cleaner_sidecar_config" {
  default = {
    name = "cleaner"
    container_resources = {
      requests_cpu    = "10m"
      limits_cpu      = "10m"
      requests_memory = "20M"
      limits_memory   = "25M"
    }
  }
}
