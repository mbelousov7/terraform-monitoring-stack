variable "namespace" {
  description = "kubernetes namespace for postgres"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
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
  default = "Always" #"IfNotPresent"#
}


variable "container_port" {
  description = "query http port, must not be changed"
  type        = number
  default     = 9090
}

variable "container_port_grpc" {
  description = "query grpc port, must not be changed"
  type        = number
  default     = 10901
}

variable "service_sidecars" {
  default = {
    name = "sidecars"
    selector = {
      module = "prometheus"
    }
    session_affinity = "None"
    type             = "ClusterIP"
    cluster_ip       = "None"
  }
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

variable "env_secret" {
  description = "main pod secret enviroment variables, values provided from outside the module"
  type        = map(any)
  default     = {}
}

variable "container_args" {
  description = "additional container args"
  default = [
    "--log.level=info",
    "--query.timeout=1m",
    "--query.max-concurrent=24",
    "--query.max-concurrent-select=12",
    "--query.auto-downsampling",
    "--query.partial-response",
    #"--store=thanos-store:10091",
  ]
}

variable "config_path" {
  description = "path to sd file"
  type        = string
  default     = "/thanos"
}

variable "prometheus_replica_label" {
  description = "prometheus replica label name, using for deduplication algorithm"
  type        = string
  default     = "prometheus_replica"
}

variable "sd_data" {
  description = "prometheus.yml config map"
  default = {
    "sd.yml" = <<EOF
- targets:
  - prometheus-h1-0.prometheus-h1:10091
  - prometheus-h1-1.prometheus-h1:10091
EOF
  }
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
  #default     = "nginx-ingress"
}

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = number
  default     = 8080
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
