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
          map_name = "config-provisioning-dashboards"
          map_path = "/etc/grafana/provisioning/dashboards"
          map_data = {
            "datasources.yaml" = file("./grafana/dashboards.yaml")
          }
        },
        //main dashboards start
        {
          map_name = "config-provisioning-dashboards-main-node-os"
          map_path = "/var/lib/grafana/dashboards/main/node-os"
          map_data = {
            "node-os.json" = file("./grafana/dashboards/main/node-os.json")
          }
        },
        //main dashboards end
        //services dashboards start
        {
          map_name = "config-provisioning-dashboards-service-clickhouse"
          map_path = "/var/lib/grafana/dashboards/service/service-clickhouse"
          map_data = {
            "service-clickhouse.json" = file("./grafana/dashboards/services/service-clickhouse.json")
          }
        }
        //services dashboards end
      ]

      secret_maps_list = [
        {
          map_name = "config-provisioning-datasources"
          map_path = "/etc/grafana/provisioning/datasources"
          map_data = {
            "datasources.yaml" = file("./grafana/datasources.yaml")
          }
        }
      ]
    },
  ]
}
