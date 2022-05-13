variable "namespace" {
  description = "namespace"
  type        = string
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "nginx-ingress"
}

variable "labels" {
  description = "labels"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  type    = number
  default = 1
}

variable "strategy" {
  type    = string
  default = "RollingUpdate"
}

variable "container_image" {
  type = string
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "container_resources" {
  default = {
    requests_cpu    = "0.2"
    limits_cpu      = "0.2"
    requests_memory = "150M"
    limits_memory   = "150M"
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
  type = string
  #default     = "None"
  default = "ClientIP"
}

variable "configMap_volumes" {
  description = "list config maps and volumes"
  type = list(object({
    mount_path      = string
    name            = string
    config_map_name = string
    config_map_data = map(string)
  }))
  # Default is being set in main.tf
  default = [
    {
      mount_path      = "/etc/prometheus"
      name            = "config-main-volume"
      config_map_name = "prometheus-config-main"
      config_map_data = {}
    }
  ]
}

variable "server_map" {
  description = "server config list"
  type = map(object({
    name           = optional(string)
    app_port       = optional(number)
    auth_locations = optional(map(list(string)))
    proxy_pass     = optional(map(string))
    ssl_data       = optional(map(string))
  }))

  validation {
    condition     = length(setintersection(["none", "basic", "kerberos", "mtls"], keys(try(var.server_map.auth_locations, { "none" = null })))) > 0
    error_message = "Attribute auth_type should be in [none|basic|kerberos|mtls]."
  }
}

variable "ca_certificate" {
  type        = string
  description = "Root Ca Cert for mTLS"
  default     = ""
}

variable "dns_path_for_config" {
  type        = string
  description = "variable resolver for upstream in server.conf depends on instance of kubernetes cluster "
  default     = "svc.cluster.local"
}

variable "route_suffix" {
  type        = string
  description = "variable for nginx ingress postfix"
  default     = "apps.cluster.local"
}

variable "nginx_users_map" {
  description = " map user_name = http_encrypted_user_password "
  default = {
    user  = "$apr1$A3L4.ORj$xGd9QkfCjDHS8tZWQldOP0" //user
    admin = "$apr1$GqeZ89R1$.qHQjuvzJIdWaFS413SgA/" //P@ssw0rd
  }
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

variable "kerberos_config" {
  description = "kerberos config"
  default     = {}
}

variable "kerberos_keytab" {
  description = "kerberos keytab"
  default     = []
}
