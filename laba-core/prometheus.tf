module "prometheus" {
  for_each = {for prometheus in local.prometheus_list:  prometheus.name => prometheus}
  source = "../modules/prometheus"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  sa_create = true
  role_create = true
  service_account_name = "prometheus"
  container_image = var.prometheus_container_image
  container_port = var.prometheus_container_port
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "200m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "300m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "0.5Gi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "0.6Gi")
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

locals {
  //configs for multiple independed prometheuses
  prometheus_list = [
    {
      name = "prometheus-infra"
      app_port = var.prometheus_container_port
      container_resources_requests_cpu = "200m"
      container_resources_limits_cpu = "300m"
      container_resources_requests_memory = "256Mi"
      container_resources_limits_memory = "300Mi"
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.crt" = file("./secrets/prometheus-infra.crt")
        "ssl_certificate_key.key" = file("./secrets/prometheus-infra.key")
      }
      config_maps_list = [
        {
          map_name = "config-prometheus-volume"
          map_path = "/etc/prometheus"
          map_data = {
            "prometheus.yml" = file("./prometheus-infra/prometheus.yml")
          }
        },
        {
          map_name = "config-file-sd-config-volume"
          map_path = "/etc/prometheus/file_sd_config"
          map_data = {
            "file_sd_config_test.json" = file("./prometheus-infra/file_sd_config/file_sd_config_test.json")
            "file_sd_config_test1.json" = file("./prometheus-infra/file_sd_config/file_sd_config_test1.json")
          }
        },
        {
          map_name = "config-rules-volume"
          map_path = "/etc/prometheus/rules"
          map_data = {
            "rules.yml" = file("./prometheus-infra/rules/rules.yml")
          }
        }
      ]
      secret_maps_list = [
        {
          map_name = "config-secret-volume"
          map_path = "/etc/prometheus/secrets"
          map_data = {
            ".password" = var.monitoring_password
          }
        }
      ]
    }
  ]
}
