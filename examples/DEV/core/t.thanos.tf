module "thanos-query" {
  //for_each нужен чтобы передавать сертификаты в nginx-ingress
  for_each                   = local.thanos_query_map
  source                     = "../../../modules/thanos-query"
  namespace                  = var.namespace
  name                       = each.key
  container_image            = var.thanos_container_image
  container_resources        = lookup(local.container_resources_thanos_query, var.env)
  container_port             = var.prometheus_container_port
  container_port_grpc        = var.thanos_port_grpc
  replicas                   = var.replicas_deployment //> 2 ? var.replicas_deployment : 3
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
  sd_data = {
    "sd.yml" = templatefile("${var.path_configs}/thanos-query-sd.yml", {
      prometheus_list      = keys(local.prometheus_map)
      replicas_statefulset = var.replicas_statefulset
      thanos_port_grpc     = var.thanos_port_grpc
    })
  }
  container_args = [
    "--log.level=info",
    "--query.timeout=1m",
    "--query.max-concurrent=24",
    "--query.max-concurrent-select=12",
    "--query.auto-downsampling",
    "--query.partial-response",
    //--store - нужен только если есть интеграция с s3 object store
    "--store=${var.thanos_store_name}:${var.thanos_port_grpc}",
  ]
}

module "thanos-query-frontend" {
  //for_each нужен чтобы передавать сертификаты в nginx-ingress
  for_each            = local.thanos_query_frontend_map
  source              = "../../../modules/thanos-query-frontend"
  namespace           = var.namespace
  name                = each.value.name
  container_image     = var.thanos_container_image
  container_port      = var.prometheus_container_port
  container_resources = lookup(local.container_resources_thanos_query_frontend, var.env)
  replicas            = var.replicas_deployment > 2 ? var.replicas_deployment : 3
  container_args = [
    "--log.level=info",
    "--log.format=logfmt",
    "--query-frontend.compress-responses",
    "--query-range.split-interval=12h",
    "--query-range.max-retries-per-request=10",
    "--query-range.max-query-parallelism=128",
    "--query-range.partial-response",
    "--labels.response-cache-max-freshness=5m",
    "--labels.split-interval=12h",
    "--labels.max-retries-per-request=10",
    "--labels.max-query-parallelism=256",
    "--labels.partial-response",
    "--query-frontend.log-queries-longer-than=10s",
  ]
  name_thanos_query          = "thanos-query"
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name

}

//thanos-store - нужен только если есть интеграция с s3 object store
module "thanos-store" {
  //for_each = local.thanos_store_map
  source              = "../../../modules/thanos-store"
  namespace           = var.namespace
  name                = var.thanos_store_name
  container_image     = var.thanos_container_image
  container_port      = var.prometheus_container_port
  container_port_grpc = var.thanos_port_grpc
  container_resources = lookup(local.container_resources_thanos_store, var.env)
  replicas            = var.replicas_deployment > 2 ? var.replicas_deployment : 3
  config_s3           = var.config_s3
  container_args = [
    "--log.level=info",
  ]
}
//thanos-compact - нужен только если есть интеграция с s3 object store
module "thanos-compact" {
  source              = "../../../modules/thanos-compact"
  namespace           = var.namespace
  name                = var.thanos_compact_name
  container_image     = var.thanos_container_image
  container_port      = var.prometheus_container_port
  container_resources = lookup(local.container_resources_thanos_compact, var.env)
  //container args parameters
  config_s3 = var.config_s3
  retention = lookup(local.thanos_compact_retention, var.env)
  container_args = [
    "--log.level=warn",
    "--delete-delay=0",
    "--consistency-delay=30m",
  ]
}

//thanos-tools-bucket-web - нужен только если есть интеграция с s3 object store
module "thanos-tools-bucket-web" {
  for_each            = local.thanos_tools_bucket_web_map
  source              = "../../../modules/thanos-tools-bucket-web"
  namespace           = var.namespace
  name                = each.key
  container_image     = var.thanos_container_image
  container_port      = var.prometheus_container_port
  container_resources = lookup(local.container_resources_thanos_tools_bucket_web, var.env)
  replicas            = var.replicas_deployment
  config_s3           = var.config_s3
  container_args = [
    "--log.level=info",
    "--refresh=5m",
  ]
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
}


locals {

  thanos_map = merge(
    local.thanos_query_map,
    local.thanos_query_frontend_map,
    local.thanos_tools_bucket_web_map,
  )

  #!!!!prometheus pods will be recreate if change thanos_sidecar_config
  thanos_sidecar_config = [{
    name                = "thanos-sidecar"
    container_image     = var.thanos_container_image
    container_port_grpc = var.thanos_port_grpc
    container_port_http = var.thanos_sidecar_port_http
    container_resources = lookup(local.container_resources_thanos_sidecar, var.env)
    //config_s3 - нужен только если есть интеграция с s3 object store
    config_s3 = var.config_s3
    container_args = [
      "--log.level=info",
      //--objstore.config-file - нужен только если есть интеграция с s3 object store
      "--objstore.config-file=/thanos/secrets/config-s3.yml",
    ]
  }]

  thanos_query_map = {
    thanos-query = {
      app_port = var.prometheus_container_port
      ssl_data = {
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }

  thanos_query_frontend_map = {
    thanos-query-frontend = {
      app_port = var.prometheus_container_port
      name     = var.thanos_query_frontend_name
      ssl_data = {
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }

  thanos_tools_bucket_web_map = {
    thanos-tools-bucket-web = {
      app_port = var.prometheus_container_port
      ssl_data = {
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }
}
