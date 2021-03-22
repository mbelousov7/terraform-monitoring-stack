# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------
variable "env" {
  description = "enviroment DEV|PSI|PROD"
  type        = string
}

variable "kubernetes_host" {
  description = "kubernetes host:port address  "
  type        = string
}

variable "kubernetes_token" {
  description = "kubernetes token"
  type        = string
}

variable "namespace" {
  description = "kubernetes namespace"
  type        = string
}

variable "path_secrets" {
  description = "path to decrypted sicrets folder "
  type        = string
  default     = "./secrets-decrypt"
}

variable "path_configs" {
  description = "path to configs files"
  type        = string
  default     = "../../global/configs"
}

variable "path_dashboards" {
  description = "path to grafana dashboards folder"
  type        = string
  default     = "../../global/dashboards"
}

variable "nginx_container_image" {
  description = "nginx_container_image"
  type        = string
}

variable "nginx_ingress_service_name" {
  description = "nginx ingress deployment name"
  type        = string
  default     = "nginx-ingress"
}

variable "expose" {
  description = "expose type none|ingress|route"
  type        = string
  default     = "route"
}

variable "route_suffix" {
  description = "route suffix"
  type        = string
}

variable "prometheus_container_image" {
  description = "image path"
  type        = string
}

variable "prometheus_container_port" {
  description = "prometheus port"
  type        = number
  default     = 9090
}

variable "prometheus_service_account_name" {
  description = "prometheus service account name fo kubernetes discovery"
  type        = string
  default     = "prometheus"
}

variable "prometheus_replica_label" {
  description = "prometheus replica label name, using for deduplication algorithm"
  type        = string
  default     = "prometheus_replica"
}


variable "thanos_query_frontend_name" {
  type    = string
  default = "thanos-query-frontend"
}

variable "thanos_store_name" {
  type    = string
  default = "thanos-store"
}

variable "thanos_compact_name" {
  type    = string
  default = "thanos-compact"
}

variable "thanos_container_image" {
  type = string
}

variable "thanos_port_grpc" {
  type    = number
  default = 10901
}

variable "thanos_sidecar_port_http" {
  type    = number
  default = 10092
}

variable "config_s3" {
  description = "s3 config if exist"
  default     = {}
}

variable "prometheus_pg_adapter_container_image" {
  description = "image path"
  type        = string
}

variable "pushgateway_container_image" {
  description = "image path"
  type        = string
}

variable "pushgateway_container_port" {
  description = "pushgateway port, DO NOT CHANGE"
  type        = number
  default     = 9091
}

variable "exporter_blackbox_container_image" {
  description = "image path"
  type        = string
}

variable "alertmanager_name" {
  description = "alertmanager statefullset name, using also in prometheus configs"
  type        = string
  default     = "alertmanager"
}

variable "alertmanager_container_image" {
  description = "image path"
  type        = string
}

variable "alertmanager_container_port" {
  description = "alertmanager port, DO NOT CHANGE"
  type        = number
  default     = 9093
}

variable "reloader_container_image" {
  description = "image path"
  type        = string
}

variable "postgres_container_image" {
  description = "image path"
  type        = string
}

variable "grafana_container_image" {
  description = "image path"
  type        = string
}

variable "fluentbit_container_image" {
  description = "image path"
  type        = string
}

variable "fluentbit_config_output" {}

variable "replicas_deployment" {
  description = "replicas count for stateless deployments"
  type        = number
  default     = 2
}

variable "replicas_statefulset" {
  description = "replicas count for statefulsets"
  type        = number
  default     = 2
}
# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------------------------------------------

variable "monitoring_user" {
  description = "user for monitoring"
  type        = string
  default     = "prometheus"
}

variable "monitoring_password" {
  description = "password for monitoring_user"
  type        = string
}

variable "nginx_users_map" {
  description = " map user_name = http_encrypted_user_password "
  default = {
    user = "$apr1$A3L4.ORj$xGd9QkfCjDHS8tZWQldOP0" //user
  }
}

variable "alertmanager_smtp_smarthost" {}
variable "alertmanager_smtp_from" {}
variable "alertmanager_smtp_auth_username" {}
variable "alertmanager_smtp_auth_password" {}

variable "alertmanager_receivers_email" {}

#variable "thanos_sidecar_config" {}
variable "prometheus_pg_adapter_env_secret" {}
variable "prometheus_pg_adapter_env" {}

variable "prometheus_os_host" {}
variable "prometheus_os_user" {}
variable "prometheus_os_password" {}

variable "elasticsearch" {}

variable "grafana_admin_user" {}
variable "grafana_admin_password" {}
variable "grafana_ldap_host" {}
variable "grafana_ldap_bind_user" {}
variable "grafana_ldap_bind_password" {}
variable "grafana_ldap_bind_suffix" {}
