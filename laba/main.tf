terraform {
  required_version = ">= 0.12"
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
  for_each = {for prometheus in local.prometheus_list:  prometheus.app_name => prometheus}
  source = "../modules/prometheus"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  app_name = each.value.app_name
  container_image = "prom/prometheus:latest"
  container_name = each.value.app_name
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "0.2")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "0.4")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "0.5")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "0.99") 
  nginx_ingress_port = var.nginx_ingress_port
  nginx_ingress_service_name = "nginx-ingress"
}
