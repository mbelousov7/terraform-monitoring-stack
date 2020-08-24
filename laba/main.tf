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

module "nginx-ingress" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring ]
  app_name = var.nginx_ingress_name
  replicas = 1
  container_image = "nginx"
  container_name = var.nginx_ingress_name
  server_list = local.prometheus_list
  auth_type = "none"
  resolver = "kube-dns.kube-system.svc.cluster.local"
}

module "prometheus" {
  for_each = {for prometheus in local.prometheus_list:  prometheus.app_name => prometheus}
  source = "../modules/prometheus"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  app_name = each.value.app_name
  container_image = "prom/prometheus:latest"
  container_name = each.value.app_name
  config_maps_list = each.value.config_maps_list
  secret_maps_list = lookup(each.value, "secret_maps_list", {})
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "200m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "400m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "254Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "512Mi")
  nginx_ingress_service_name = var.nginx_ingress_name
  nginx_ingress_port = var.nginx_ingress_port
}
