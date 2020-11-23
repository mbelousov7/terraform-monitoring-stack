terraform {
  required_version = ">= 0.13"
}

provider "kubernetes" {
  version = ">= 1.10.0"
  load_config_file       = false
  insecure               = true
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

module "prometheus" {
  for_each = {for prometheus in local.prometheus_list:  prometheus.name => prometheus}
  source = "../modules/prometheus"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  service_account_name = "default"
  container_image = var.prometheus_container_image
  container_port = var.prometheus_container_port
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "1000m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "1500m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "2Gi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "3Gi")
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

module "alertmanager" {
  for_each = {for alertmanager in local.alertmanager_list:  alertmanager.name => alertmanager}
  source = "../modules/alertmanager"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  name_replica  = each.value.name_replica
  container_image = var.alertmanager_container_image
  container_port = var.alertmanager_container_port
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_resources_requests_cpu = "100m"
  container_resources_limits_cpu = "150m"
  container_resources_requests_memory = "100Mi"
  container_resources_limits_memory = "128Mi"
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

module "pushgateway" {
  for_each = {for pushgateway in local.pushgateway_list:  pushgateway.name => pushgateway}
  source = "../modules/pushgateway"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  container_image = "prom/pushgateway:latest"
  container_port = var.pushgateway_container_port
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "50m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "90m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "64Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "100Mi")
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

module "nginx-ingress" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [
    kubernetes_namespace.monitoring,
    module.alertmanager.service_name,
    module.prometheus.service_name,
    module.pushgateway.service_name
  ]
  name = "nginx-ingress"
  replicas = 3
  container_image = var.nginx_container_image
  server_list = concat(
    local.alertmanager_list,
    local.prometheus_list,
    local.pushgateway_list
  )
  container_resources_requests_cpu = "50m"
  container_resources_limits_cpu = "90m"
  container_resources_requests_memory = "150Mi"
  container_resources_limits_memory = "250Mi"
  auth_type = "basic"
  resolver = var.resolver
  route_path_for_config = var.route_path_for_config
  service_type = "LoadBalancer"
}

//module for one postgres for one grafana.
//grafana_list in not supported becouse of module dependensy

module "grafana-postgres" {
  source = "../modules/postgres"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = var.grafana_env_secret.DATABASE_SERVICE
  env_secret = {
    POSTGRES_USER = var.grafana_env_secret.GF_DATABASE_USER
    POSTGRES_PASSWORD = var.grafana_env_secret.GF_DATABASE_PASSWORD
    POSTGRES_DB = var.grafana_env_secret.GF_DATABASE_NAME
  }
  container_image = var.postgres_container_image
}

//module for one grafana

module "grafana" {
  source = "../modules/grafana"
  depends_on = [ kubernetes_namespace.monitoring , module.grafana-postgres.service_name ]
  namespace = var.namespace
  replicas = 1
  name = local.grafana.name
  env = local.grafana.env
  env_secret = local.grafana.env_secret
  config_maps_list = lookup(local.grafana, "config_maps_list", [])
  secret_maps_list = lookup(local.grafana, "secret_maps_list", [])
  ssl_data = lookup(local.grafana, "ssl_data", {})
  container_image = var.grafana_container_image
  expose = "ingress"
  service_type = "LoadBalancer"
  container_resources_requests_cpu = lookup(local.grafana, "container_resources_requests_cpu", "100m")
  container_resources_limits_cpu = lookup(local.grafana, "container_resources_limits_cpu", "200m")
  container_resources_requests_memory = lookup(local.grafana, "container_resources_requests_memory", "128M")
  container_resources_limits_memory = lookup(local.grafana, "container_resources_limits_memory", "256M")
}

/*
module "nginx-ingress-alertmanager-list" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring, module.alertmanager.service_name ]
  name = "nginx-ingress-alertmanager-list"
  replicas = 1
  container_image = var.nginx_container_image
  server_list = local.alertmanager_list
  auth_type = "basic"
  resolver = var.resolver
  route_path_for_config = var.route_path_for_config
  service_type = "LoadBalancer"
}
*/

/*
module "nginx-ingress-pushgateway-list" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring ]
  name = "nginx-ingress-pushgateway-list"
  replicas = 1
  container_image = "nginx"
  server_list = local.pushgateway_list
  auth_type = "basic"
  resolver = var.resolver
  route_path_for_config = var.route_path_for_config
  service_type = "LoadBalancer"
}
*/

/*
module "nginx-ingress-prometheus-list" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring, module.prometheus.service_name ]
  name = "nginx-ingress-prometheus-list"
  replicas = 1
  container_image = var.nginx_container_image
  server_list = local.prometheus_list
  auth_type = "basic"
  resolver = var.resolver
  route_path_for_config = var.route_path_for_config
  service_type = "LoadBalancer"
}
*/
