variable "namespace" {
  description = "kubernetes namespace for prometheus"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "alertmanager"
}

#variable "name_replica" {
#  description = "second alertmanager peer name"
#  type        = string
#}

variable "labels" {
  description = "additional kubernetes labels, values provided from outside the module"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = number
  default     = 3
}

#variable "strategy" {
#  type        = string
#  default     = "Recreate"
#}

variable "pod_management_policy" {
  type    = string
  default = "OrderedReady"
}

variable "update_strategy" {
  type    = string
  default = "RollingUpdate"
}

variable "container_image" {
  description = "path to prometheus image"
  type        = string
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}

variable "configPath" {
  description = "path to configs folder"
  type        = string
  default     = "/etc/alertmanager"
}

variable "config_data" {
  description = "alertmanager.yml config map"
  default = {
    "alertmanager.yml" = <<EOF

EOF
  }
}

variable "dns_path_for_config" {
  type        = string
  description = "variable resolver for upstream in server.conf depends on instance of kubernetes cluster "
  default     = "svc.cluster.local"
}

variable "dataPath" {
  description = "path to data folder"
  type        = string
  default     = "/data"
}

variable "retentionTime" {
  type    = string
  default = "170h"
}

variable "container_port" {
  type    = number
  default = 9093
}

variable "cluster_port" {
  type    = number
  default = 9094
}

variable "cluster_peer_add_list" {
  description = "additional alertmanagers peer list(from other kuber cluster or namespace)"
  type        = list(any)
  default     = []
}


variable "container_resources" {
  default = {
    requests_cpu    = "0.05"
    limits_cpu      = "0.05"
    requests_memory = "50M"
    limits_memory   = "50M"
    size_limit      = "1Gi"
    requests_ephemeral_storage = "1Gi"
    limits_ephemeral_storage = "1Gi"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 120
    timeout_seconds       = 30
    period_seconds        = 60
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 120
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

variable "container_extra_args" {
  description = "extra command line arguments to pass to conatiner"
  type        = list(string)
  default     = []
}