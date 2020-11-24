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
  depends_on = [
    kubernetes_namespace.monitoring,
    module.alertmanager.service_name,
    module.prometheus.service_name,
    module.pushgateway.service_name
  ]
  name = "nginx-ingress"
  replicas = 1
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
