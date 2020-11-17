locals {
  //configs for multiple independed prometheuses
  grafana_list = [
    {
      name = "grafana"
      container_resources_requests_cpu = "100m"
      container_resources_limits_cpu = "200m"
      container_resources_requests_memory = "128M"
      container_resources_limits_memory = "264M"
      env = {
        GF_PATHS_PROVISIONING = "/etc/grafana/provisioning"
        GF_PATHS_CONFIG = "/etc/grafana/grafana.ini"
        GF_DATABASE_HOST = "grafana-db"
        GF_DATABASE_NAME = "grafana"
        GF_DATABASE_TYPE = "sqlite3"
      }
      //grafana_env_secret in secrets/secrets.tfvars
      env_secret = var.grafana_env_secret
      ssl_data = {
        "ssl_certificate.crt" = file("./secrets/grafana.crt")
        "ssl_certificate_key.key" = file("./secrets/grafana.key")
      }
      config_maps_list = [
        {
          mount_path = "/etc/grafana/provisioning/datasources1"
          name = "config-provisioning-datasources1"
          config_map_name = "config-provisioning-datasources1"
          config_map_data = {
            "datasources.yaml" = file("./grafana/datasources.yaml")
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
          mount_path = "/etc/grafana/provisioning/datasources"
          name = "config-provisioning-datasources"
          secret_name = "config-provisioning-datasources"
          secret_data = {
            "datasources.yaml" = file("./grafana/datasources.yaml")
          }
        }
      ]
    },
  ]
}
