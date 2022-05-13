variable "namespace" {
  description = "kubernetes namespace for thanos-memcached"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "thanos-memcached"
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
  description = "image path"
  type        = string
  #  default     = ""
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}

variable "container_port" {
  description = "memcached port"
  type        = number
  default     = 11211
}

variable "container_port_metrics" {
  description = "memcached metrics port"
  type        = number
  default     = 9150
}

variable "container_args" {
  description = "additional container args"
  default     = []
}

variable "container_resources" {
  default = {
    requests_cpu               = "0.2"
    limits_cpu                 = "0.2"
    requests_memory            = "1512M"
    limits_memory              = "2048M"
    requests_ephemeral_storage = "5Gi"
    limits_ephemeral_storage   = "5Gi"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 5
    timeout_seconds       = 5
    period_seconds        = 15
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 10
    timeout_seconds       = 5
    period_seconds        = 15
    failure_threshold     = 3
  }
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "service_cluster_ip" {
  type    = string
  default = "None"
}

variable "session_affinity" {
  type    = string
  default = "None"
  #default     = "ClientIP"
}

variable "service_account_name" {
  type    = string
  default = "default"
}

variable "automount_service_account_token" {
  type    = bool
  default = false
}

variable "service_account_token_name" {
  default = "default"
  type    = string
}
