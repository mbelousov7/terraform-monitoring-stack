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
  container_image = var.prometheus_container_image
  container_port = var.prometheus_container_port
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "200m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "400m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "254Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "512Mi")
  expose = "ingress"
  nginx_ingress_service_name = "nginx-ingress-prometheus-list"
}

module "nginx-ingress-prometheus-list" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring, module.prometheus.service_name ]
  name = "nginx-ingress-prometheus-list"
  replicas = 1
  container_image = "nginx"
  server_list = local.prometheus_list
  auth_type = "basic"
  resolver = var.resolver
  route_path_for_config = var.route_path_for_config
  app_port = var.prometheus_container_port
  service_type = "LoadBalancer"
}

module "pushgateway" {
  for_each = {for pushgateway in local.pushgateway_list:  pushgateway.name => pushgateway}
  source = "../modules/pushgateway"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  container_image = "prom/pushgateway:latest"
  container_port = var.pushgateway_container_port
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "100m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "200m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "64Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "128Mi")
  expose = "ingress"
  nginx_ingress_service_name = "nginx-ingress-pushgateway-list"
  #nginx_ingress_port = var.nginx_ingress_port
}

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
  app_port = var.pushgateway_container_port
  service_type = "LoadBalancer"
}

module "grafana" {
  for_each = {for grafana in local.grafana_list:  grafana.name => grafana}
  source = "../modules/grafana"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_image = "grafana/grafana:latest"
  expose = "ingress"
  service_type = "LoadBalancer"
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "100m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "200m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "128M")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "256M")
}
