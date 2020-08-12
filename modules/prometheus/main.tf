locals {
  labels = merge (
    { app = var.app_name },
    var.labels
  )

  configMap_volumes =   concat(
    [
      {
        mount_path = "/etc/prometheus"
        name = "config-main-volume"
        config_map_name = "${var.app_name}-config-main"
        config_map_data = {
          "prometheus.yaml" = file("./${var.app_name}/prometheus.yaml")
        }
      },
      {
        mount_path = "/etc/prometheus/rules"
        name = "config-rules-volume"
        config_map_name = "${var.app_name}-config-rules"
        config_map_data = {
          "rules.yaml" = file("./${var.app_name}/rules.yaml")
        }
      }
    ],
    var.configMap_file_sd_config_volumes
  )
}
