locals {
  prometheus_list = [
    {
      app_name = "prometheus-cdh-dc"
      config_map_data = [
        {
          #for_each = fileset("./prometheus-cdh-dc/file_sd_config", "*")
          #  each.value = file("./prometheus-cdh-dc/file_sd_config/${each.value}")
          "file_sd_config_test.yaml" = file("./prometheus-cdh-dc/file_sd_config/file_sd_config_test.json")
          "file_sd_config_test1.yaml" = file("./prometheus-cdh-dc/file_sd_config/file_sd_config_test1.json")
        },
        {
          "rules.yaml" = file("./prometheus-cdh-dc/rules/rules.yaml")
        }
      ]
    }
  ]
}

module "prometheus" {
  for_each = {for prometheus in local.prometheus_list:  prometheus.app_name => prometheus}
  source = "../modules/prometheus"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  app_name = each.value.app_name
  container_image = "prom/prometheus:latest"
  container_name = each.value.app_name
  nginx_ingress_port = var.nginx_ingress_port
  nginx_ingress_service_name = "nginx-ingress"
  configMap_file_sd_config_volumes = [
    {
      mount_path = "/etc/prometheus/file_sd_config"
      name = "config-filesd-volume"
      config_map_name = "config-filesd"
      config_map_data = each.value.config_map_data
    }
  ]
}
