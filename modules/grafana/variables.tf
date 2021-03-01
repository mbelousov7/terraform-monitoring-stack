variable "namespace" {
  description = "kubernetes namespace for grafana"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "grafana"
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
  type        = string
  default     = "OrderedReady"
}

variable "update_strategy" {
  type        = string
  default     = "RollingUpdate"
}

variable "container_image" {
  description = "path to grafana image"
  type        = string
}

variable "image_pull_policy" {
  type        = string
  default     = "Always"
}

variable "env" {
  description = "main pod enviroment variables, values provided from outside the module"
  type        = map
  default     = {
    GF_PATHS_PROVISIONING = "/etc/grafana/provisioning"
    GF_PATHS_CONFIG = "/etc/grafana/grafana.ini"
    GF_DATABASE_HOST = "grafana-db"
    GF_DATABASE_NAME = "grafana"
    GF_DATABASE_TYPE = "sqlite3"
    #GF_SERVER_PROTOCOL = "https"
    #GF_SERVER_CERT_FILE = "/etc/grafana/cert/grafana.crt"
    #GF_SERVER_KEY_FILE = "/etc/grafana/cert/grafana.key"
  }
}

variable "env_secret" {
  description = "main pod secret enviroment variables, values provided from outside the module"
  type        = map
  default     = {
    GF_SECURITY_ADMIN_USER = "admin"
    GF_SECURITY_ADMIN_PASSWORD = "password"
    GF_DATABASE_USER = "admin"
    GF_DATABASE_PASSWORD = "password"
  }
}

variable "container_port" {
  type        = number
  default     = 3000
}

variable "container_resources" {
  default = {
    requests_cpu = "100m"
    limits_cpu ="150m"
    requests_memory = "150Mi"
    limits_memory = "250Mi"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 60
    timeout_seconds = 15
    period_seconds = 60
    failure_threshold = 5
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 60
    timeout_seconds = 5
    period_seconds = 30
    failure_threshold = 1
  }
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "session_affinity" {
  type        = string
  default     = "ClientIP"
}

variable "dashboards_map" {
  description = "dashboards map"
  //type = map(map(
  //  folder = string
  //  json = string
//  ))
  default = {
    system-template-jmx = { folder = "main" }
    system-template-os = { folder = "main" }
  }
}

variable "dashboards_folder" {
  description = "folder path dashboards .json's "
  type = string
  default = "./dashboards"
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

variable "ssl_data" {
  description = "ssl cert and key"
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

variable "fluentbit_container_image" {
  description = "path to fluentbit image"
  type        = string
}

variable "fluentbit_config" {
  default     = {
      name = "fluentbit"
      container_resources = {
        requests_cpu = "10m"
        limits_cpu = "10m"
        requests_memory = "20M"
        limits_memory = "20M"
      }
    }
}

variable "fluentbit_config_output" {
/*  default     = {
      host = "logs"
      port = "44442"
      app_id = "monitor"
    } */
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
