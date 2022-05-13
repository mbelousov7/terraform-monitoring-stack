variable "namespace" {
  description = "kubernetes namespace for postgres"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "bucket-web"
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
  description = "image path"
  type        = string
  #  default     = ""
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}


variable "container_port" {
  description = "query http port, must not be changed"
  type        = number
  default     = 9090
}


variable "container_resources" {
  default = {
    requests_cpu    = "0.2"
    limits_cpu      = "0.2"
    requests_memory = "250M"
    limits_memory   = "260M"
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

variable "session_affinity" {
  type    = string
  default = "None"
  #default     = "ClientIP"
}

variable "container_args" {
  description = "additional container args"
  default = [
    "--log.level=info",
  ]
}



variable "config_path" {
  description = "path to configs files"
  type        = string
  default     = "/thanos/configs"
}

variable "config_path_s3" {
  description = "path to secrets files"
  type        = string
  default     = "/thanos/secrets"
}

variable "config_s3" {
  default = {}
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
  default     = "nginx-ingress"
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = number
  default     = 8080
}
