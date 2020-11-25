//module for one postgres for one grafana.
//grafana_list in not supported becouse of module dependensy

module "grafana-postgres" {
  source = "../modules/postgres"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = var.grafana_env_secret.DATABASE_SERVICE
  env_secret = {
    POSTGRES_USER = var.grafana_env_secret.GF_DATABASE_USER
    POSTGRES_PASSWORD = var.grafana_env_secret.GF_DATABASE_PASSWORD
    POSTGRES_DB = var.grafana_env_secret.GF_DATABASE_NAME
  }
  container_image = var.postgres_container_image
}

//module for one grafana

module "grafana" {
  source = "../modules/grafana"
  depends_on = [ kubernetes_namespace.monitoring , module.grafana-postgres.service_name ]
  namespace = var.namespace
  replicas = 1
  name = local.grafana.name
  env = local.grafana.env
  env_secret = local.grafana.env_secret
  config_maps_list = lookup(local.grafana, "config_maps_list", [])
  secret_maps_list = lookup(local.grafana, "secret_maps_list", [])
  ssl_data = lookup(local.grafana, "ssl_data", {})
  container_image = var.grafana_container_image
  expose = "ingress"
  service_type = "LoadBalancer"
  container_resources_requests_cpu = lookup(local.grafana, "container_resources_requests_cpu", "100m")
  container_resources_limits_cpu = lookup(local.grafana, "container_resources_limits_cpu", "200m")
  container_resources_requests_memory = lookup(local.grafana, "container_resources_requests_memory", "128M")
  container_resources_limits_memory = lookup(local.grafana, "container_resources_limits_memory", "256M")
}

locals {
  //configs for  grafana
  grafana = {
      name = "grafana"
      container_resources_requests_cpu = "100m"
      container_resources_limits_cpu = "150m"
      container_resources_requests_memory = "150M"
      container_resources_limits_memory = "200M"
      env = {
        GF_PATHS_PROVISIONING = "/etc/grafana/provisioning"
        GF_PATHS_CONFIG = "/etc/grafana/grafana.ini"
        GF_DATABASE_TYPE = "postgres"
        GF_SERVER_PROTOCOL = "https"
        GF_SERVER_CERT_FILE = "/etc/grafana/cert/grafana.crt"
        GF_SERVER_CERT_KEY = "/etc/grafana/cert/grafana.key"
      }
      //grafana database config
      database = {

      }
      //grafana_env_secret in secrets/secrets.tfvars
      env_secret = var.grafana_env_secret
      //grafana cert's files for https
      ssl_data = {
        "grafana.crt" = file("./secrets/grafana.crt")
        "grafana.key" = file("./secrets/grafana.key")
      }

      config_maps_list = [
        {
          map_name = "config-provisioning-plugins"
          map_path = "/etc/grafana/provisioning/plugins"
          map_data = {
            "plugins.yml" = file("./grafana/plugins.yml")
          }
        },
        {
          map_name = "config-provisioning-dashboards"
          map_path = "/etc/grafana/provisioning/dashboards"
          map_data = {
            "datasources.yml" = file("./grafana/dashboards.yml")
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
            "datasources.yml" = file("./grafana/datasources.yml")
          }
        }
      ]
    }
}
