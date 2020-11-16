locals {
  //configs for multiple independed prometheuses
  grafana_list = [
    {
      name = "grafana"
      container_resources_requests_cpu = "100m"
      container_resources_limits_cpu = "200m"
      container_resources_requests_memory = "128M"
      container_resources_limits_memory = "264M"
      ssl_data = {
        "ssl_certificate.crt" = file("./secrets/nginx.crt")
        "ssl_certificate_key.key" = file("./secrets/nginx.key")
      }
      config_maps_list = [
        {
          mount_path = "/etc/grafana_provisioning"
          name = "config-provisioning"
          config_map_name = "config-provisioning"
          config_map_data = {
            "prometheus.yaml" = file("./prometheus-infra/prometheus.yaml")
          }
        },
        {
          mount_path = "/etc/grafana_config"
          name = "config-grafana"
          config_map_name = "config-grafana"
          config_map_data = {
            "grafana.ini" = file("./grafana/grafana.ini")
          }
        }
      ]
      secret_maps_list = [
        {
          mount_path = "/etc/grafana_secrets"
          name = "config-secret"
          secret_name = "config-secret"
          secret_data = {
            ".password" = var.monitoring_password
          }
        }
      ]
    },
  ]
}
