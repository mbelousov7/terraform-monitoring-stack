module "prometheus-h" {
  #for_each = {for prometheus in local.prometheus_h_list:  prometheus.name => prometheus}
  for_each              = local.prometheus_h_map
  source                = "../../../modules/prometheus"
  namespace             = var.namespace
  name                  = each.key
  container_image       = var.prometheus_container_image
  container_resources   = lookup(local.container_resources_prometheus_h, var.env)
  container_port        = var.prometheus_container_port
  replicas              = var.replicas_statefulset
  thanos_sidecar_config = local.thanos_sidecar_config
  config_data = {
    for i in range(var.replicas_statefulset) : "prometheus-${i}.yml" => templatefile("${var.path_configs}/prometheus-h.yml", {
      namespace                   = var.namespace
      prometheus_name             = each.key
      replicas_statefulset        = var.replicas_statefulset
      alertmanager_name           = var.alertmanager_name
      alertmanager_container_port = var.alertmanager_container_port
      prometheus_replica_label    = var.prometheus_replica_label
      prometheus_replica          = tostring(i)
      h-clusters                  = lookup(local.prometheus_h_clusters_map, each.key, [])
    })
  }
  rules_data = {
    "jmx.yml" = file("${var.path_configs}/prometheus-rules/prometheus-rules-jmx.yml")
    "os.yml"  = file("${var.path_configs}/prometheus-rules/prometheus-rules-os.yml")
  }
  targets_folder   = "./prometheus-targets-h"
  targets_list     = lookup(local.prometheus_h_clusters_map, each.key, [])
  config_maps_list = []
  secret_maps_list = [
    {
      map_name = "config-secret"
      map_path = "/etc/prometheus/secrets"
      map_data = {
        ".password" = var.monitoring_password
      }
    }
  ]
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
  service_account_name       = var.prometheus_service_account_name
}

locals {
  //configs for multiple prometheuses for hadoop clusters monitoring
  prometheus_h_map = {

    prometheus-h1 = {
      app_port = var.prometheus_container_port
      ssl_data = {
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    },

    prometheus-h2 = {
      app_port = var.prometheus_container_port
      ssl_data = {
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }

  }
}
