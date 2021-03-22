variable "namespace" {
  description = "kubernetes namespace for postgres"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "thanos-query-frontend"
}


variable "name_thanos_query" {
  description = "thanos query name, using for pod_affinity"
  type        = string
  default     = "thanos-query"
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
  default = "IfNotPresent" #"Always"
}


variable "container_port" {
  description = "query http port, must not be changed"
  type        = number
  default     = 9090
}

variable "container_resources" {
  default = {
    requests_cpu    = "0.05"
    limits_cpu      = "0.05"
    requests_memory = "200M"
    limits_memory   = "250M"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 10
    timeout_seconds       = 5
    period_seconds        = 60
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 15
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
  type = string
  #default     = "None"
  default = "ClientIP"
}

variable "env_secret" {
  description = "main pod secret enviroment variables, values provided from outside the module"
  type        = map(any)
  default     = {}
}

variable "container_args" {
  description = "additional container args"
  default = [
    "--log.level=info",
    "--log.format=logfmt",
    "--query-frontend.compress-responses",
    "--query-range.split-interval=12h",
    "--query-range.max-retries-per-request=10",
    "--query-range.max-query-parallelism=128",
    "--query-range.partial-response",
    "--labels.response-cache-max-freshness=5m",
    "--labels.split-interval=12h",
    "--labels.max-retries-per-request=10",
    "--labels.max-query-parallelism=256",
    "--labels.partial-response",
    "--query-frontend.log-queries-longer-than=10s",
  ]
}

variable "config_path" {
  description = "path to sd file"
  type        = string
  default     = "/thanos"
}


#max_size_items: 2048

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
  #default     = "nginx-ingress"
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = number
  default     = 8080
}
