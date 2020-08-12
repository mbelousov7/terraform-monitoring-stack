module "prometheus" {
  source = "../modules/prometheus"
  namespace = var.namespace
  app_name = "prometheus-cdh-dc"
  container_image = "prom/prometheus:latest"
  container_name = "prometheus"
  configMap_file_sd_config_volumes = [
    {
      mount_path = "/etc/prometheus/file_sd_config"
      name = "config-filesd-volume"
      config_map_name = "config-filesd"
      config_map_data = {}
    }
  ]
}
