module "prometheus-pg" {
  #for_each = {for prometheus in local.prometheus_pg:  prometheus.name => prometheus}
  for_each                 = local.prometheus_pg_map
  source                   = "../../../modules/prometheus-pg"
  namespace                = var.namespace
  name                     = each.key
  container_image          = var.prometheus_container_image
  reloader_container_image = var.reloader_container_image
  container_resources      = lookup(local.container_resources_prometheus_pg, var.env)
  container_port           = var.prometheus_container_port
  replicas                 = 1 //var.replicas_statefulset
  config_data = {
    for i in range(var.replicas_statefulset) : "prometheus-${i}.yml" => templatefile("${var.path_configs}/prometheus-pg.yml", {
      namespace          = var.namespace
      prometheus_name    = each.key
      prometheus_replica = tostring(i)
    })
  }
  pg_adapter_config          = local.pg_adapter_config
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
  service_account_name       = var.prometheus_service_account_name
}

locals {
  //configs for prometheus-pg
  prometheus_pg_map = {
    prometheus-pg = {
      app_port = var.prometheus_container_port
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }

  pg_adapter_config = {
    name            = "pg-adapter"
    container_image = var.prometheus_pg_adapter_container_image
    container_port  = "9201"
    env             = var.prometheus_pg_adapter_env
    env_secret      = var.prometheus_pg_adapter_env_secret
    container_resources = {
      requests_cpu    = "0.5"
      limits_cpu      = "0.5"
      requests_memory = "1024M"
      limits_memory   = "1024M"
    }
  }
}
