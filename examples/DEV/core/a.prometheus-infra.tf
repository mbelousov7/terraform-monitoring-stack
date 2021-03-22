module "prometheus-infra" {
  for_each              = local.prometheus_infra_map
  source                = "../../../modules/prometheus"
  namespace             = var.namespace
  name                  = each.key
  container_image       = var.prometheus_container_image
  container_resources   = lookup(local.container_resources_prometheus_infra, var.env)
  container_port        = var.prometheus_container_port
  replicas              = var.replicas_statefulset
  thanos_sidecar_config = local.thanos_sidecar_config
  config_data = {
    for i in range(var.replicas_statefulset) : "prometheus-${i}.yml" => templatefile("${var.path_configs}/prometheus-infra-${var.env}.yml", {
      namespace                   = var.namespace
      prometheus_name             = each.key
      replicas_statefulset        = var.replicas_statefulset
      alertmanager_name           = var.alertmanager_name
      alertmanager_container_port = var.alertmanager_container_port
      prometheus_replica          = tostring(i)
      prometheus_replica_label    = var.prometheus_replica_label
      systems                     = lookup(local.prometheus_infra_system_map, each.key, [])
    })
  }
  rules_data = {
    "service-kamon.yml" = file("${var.path_configs}/prometheus-rules/prometheus-rules-service-kamon.yml")
    "service-ldap"      = file("${var.path_configs}/prometheus-rules/prometheus-rules-service-ldap.yml")
    "jmx.yml"           = file("${var.path_configs}/prometheus-rules/prometheus-rules-jmx.yml")
    "os.yml"            = file("${var.path_configs}/prometheus-rules/prometheus-rules-os.yml")
  }

  targets_folder   = "./prometheus-targets-infra"
  targets_list     = lookup(local.prometheus_infra_system_map, each.key, [])
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
  //configs for multiple independed prometheuses
  prometheus_infra_map = {
    prometheus-infra = {
      app_port = var.prometheus_container_port
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }

}
