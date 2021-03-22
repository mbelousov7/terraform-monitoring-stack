
module "nginx-ingress" {
  source    = "../../../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [
    module.prometheus-infra.service_name,
    module.prometheus-h.service_name,
    module.prometheus-pg.service_name,
    module.alertmanager.service_name,
    module.pushgateway.service_name,
    module.thanos-query.service_name,
    module.thanos-query-frontend.service_name,
  ]
  name                = var.nginx_ingress_service_name
  replicas            = var.replicas_deployment + 1
  container_resources = lookup(local.container_resources_nginx, var.env)
  container_image     = var.nginx_container_image
  server_map = merge(
    local.alertmanager_map,
    local.prometheus_map,
    local.prometheus_pg_map,
    local.pushgateway_map,
    local.thanos_map,
  )
  auth_type        = "basic"
  nginx_users_map  = var.nginx_users_map
  service_type     = "ClusterIP"
  session_affinity = "None"
}

locals {

  prometheus_map = merge(
    local.prometheus_infra_map,
    local.prometheus_h_map,
  )


}
