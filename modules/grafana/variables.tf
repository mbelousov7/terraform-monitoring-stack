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

variable "strategy" {
  type        = string
  default     = "Recreate"
}

variable "container_image" {
  description = "path to grafana image"
  type        = string
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

variable "container_resources_requests_cpu" {
  type        = string
  default     = "100m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "128M"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "200m"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "254M"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "config_maps_list" {
  description = "list config maps and volumes"
  type = list(object({
  mount_path = string
  name = string
  config_map_name = string
  config_map_data = map(string)
}))
## Default is being set in main.tf
#default = [
#  {
#    mount_path = "/etc/grafana"
#    name = "config-main-volume"
#    config_map_name = "grafana-config-main"
#    config_map_data = {}
#  }
#]
}

variable "secret_maps_list" {
  description = "list secret maps and volumes"
  type = list(object({
  mount_path = string
  name = string
  secret_name = string
  secret_data = map(string)
}))
## Default is being set in main.tf
#default = [
#  {
#    mount_path = "/etc/grafana/secrets"
#    name = "config-secret-volume"
#    secret_name = "grafana-secret"
#    secret_data = {}
#  }
#]
}

variable "expose" {
  description = "expose resource type(ingress for kubernetes or route for openshift)"
  type        = string
  default     = "ingress"
}
