variable "namespace" {
  description = "kubernetes namespace for prometheus"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "prometheus"
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

variable "pod_management_policy" {
  type    = string
  default = "OrderedReady"
}

variable "update_strategy" {
  type    = string
  default = "RollingUpdate"
}

variable "sa_create" {
  description = "flag is it nessesary to create sa"
  type        = bool
  default     = false
}

variable "role_create" {
  description = "flag is it nessesary to create role"
  type        = bool
  default     = false
}

variable "role_binding" {
  description = "flag is it nessesary to create role"
  type        = bool
  default     = false
}

variable "service_account_name" {
  type    = string
  default = "default"
}

variable "automount_service_account_token" {
  type    = bool
  default = true
}

variable "container_image" {
  description = "path to prometheus image"
  type        = string
}

variable "image_pull_policy" {
  type    = string
  default = "IfNotPresent" #"Always"
}

variable "configPath" {
  description = "path to configs folder"
  type        = string
  default     = "/etc/prometheus/config"
}

variable "dataPath" {
  description = "path to data folder"
  type        = string
  default     = "/data"
}

variable "retentionTime" {
  type    = string
  default = "1d"
}

variable "retentionSize" {
  type    = string
  default = "5GB"
}

variable "container_port" {
  type    = number
  default = 9090
}

variable "container_resources" {
  default = {
    requests_cpu    = "200m"
    limits_cpu      = "300m"
    requests_memory = "400Mi"
    limits_memory   = "500Mi"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 5
    timeout_seconds       = 30
    period_seconds        = 60
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 5
    timeout_seconds       = 30
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
  default = "ClientIP"
}

variable "dataVolume" {
  default = {
    name      = "storage-volume"
    empty_dir = {}
  }
}

variable "config_data" {
  description = "prometheus.yml config map"
  default = {
    "prometheus.yml" = <<EOF
global:
  scrape_interval: 1m
  scrape_timeout: 30s
EOF
  }
}

variable "targets_list" {
  description = "targets names lists for prometheus"
  type        = list(string)
  default     = []
}

variable "targets_folder" {
  description = "folder path to  .json's "
  type        = string
  default     = "./"
}

variable "config_maps_list" {
  description = "list config maps and volumes"
  type = list(object({
    map_name = string
    map_path = string
    map_data = map(string)
  }))
  default = []
  ## Default is being set in main.tf
  #default = [
  #  {
  #    map_path = "/etc/grafana"
  #    map_name = "config-main-volume"
  #    config_map_name = "grafana-config-main"
  #    map_data = {}
  #  }
  #]
}

variable "secret_maps_list" {
  description = "list secret maps and volumes"
  type = list(object({
    map_name = string
    map_path = string
    map_data = map(string)
  }))
  default = []
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

variable "pg_adapter_config" {
  default = {}
  /* EXAMPLE
  [
    {
      name = "adapter-pg"
      container_image = var.prometheus_pg_adapter_container_image
      env = {}
      env_secret = var.prometheus_pg_adapter_env_secret
      container_resources = {
        requests_cpu = "200m"
        limits_cpu = "350m"
        requests_memory = "400Mi"
        limits_memory = "500Mi"
      }
    }
  ]
  */
}

variable "reloader_container_image" {
  description = "path to configmap-reloader image"
  type        = string
}

variable "reloader_sidecar_config" {
  default = {
    name           = "reloader"
    container_port = 9533
    container_resources = {
      requests_cpu    = "20m"
      limits_cpu      = "20m"
      requests_memory = "30M"
      limits_memory   = "30M"
    }
  }
}
