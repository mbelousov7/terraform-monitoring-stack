//module for one postgres for one grafana.
//grafana_list in not supported becouse of module dependensy

module "grafana-postgres" {
  source    = "../../../modules/postgres"
  namespace = var.namespace
  name      = local.grafana.env.GF_DATABASE_SERVICE
  replicas  = var.replicas_statefulset
  /* pgsql v15 example
  env_secret = {
    POSTGRES_USER = ""
    POSTGRES_PASSWORD = ""
    POSTGRES_DB = ""
  }
  */
  env_secret = {
    POSTGRESQL_USER     = local.grafana.env_secret.GF_DATABASE_USER
    POSTGRESQL_PASSWORD = local.grafana.env_secret.GF_DATABASE_PASSWORD
    POSTGRESQL_DATABASE = local.grafana.env.GF_DATABASE_NAME
  }
  container_image = var.postgres_container_image
}

//module for one grafana

module "grafana" {
  source                    = "../../../modules/grafana"
  depends_on                = [module.grafana-postgres.app_name]
  namespace                 = var.namespace
  replicas                  = var.replicas_deployment
  name                      = local.grafana.name
  env                       = local.grafana.env
  env_secret                = local.grafana.env_secret
  dashboards_map            = local.grafana.dashboards_map
  dashboards_folder         = var.path_dashboards
  config_maps_list          = lookup(local.grafana, "config_maps_list", [])
  secret_maps_list          = lookup(local.grafana, "secret_maps_list", [])
  ssl_data                  = lookup(local.grafana, "ssl_data", {})
  container_image           = var.grafana_container_image
  container_resources       = lookup(local.container_resources_grafana, var.env)
  fluentbit_container_image = var.fluentbit_container_image
  fluentbit_config_output = {
    app_id           = var.fluentbit_config_output.app_id
    http_output_host = var.fluentbit_config_output.host
    http_output_port = var.fluentbit_config_output.port
    es_output_host   = var.elasticsearch.host
    es_output_port   = var.elasticsearch.port
  }
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
}

locals {
  //configs for  grafana
  grafana = {
    name = "grafana"
    env = {
      GF_PATHS_PROVISIONING  = "/etc/grafana/provisioning"
      GF_PATHS_CONFIG        = "/etc/grafana/grafana.ini"
      GF_PATHS_LOGS          = "/var/log/grafana"
      GF_LOG_MODE            = "file console"
      GF_DATABASE_TYPE       = "postgres"
      GF_SERVER_PROTOCOL     = "https"
      GF_USERS_ALLOW_SIGN_UP = "true"
      GF_SERVER_CERT_FILE    = "/etc/grafana/cert/grafana.pem"
      GF_SERVER_CERT_KEY     = "/etc/grafana/cert/grafana.key"
      //GF_DATABASE_HOST - pod name:port  - not service name
      GF_DATABASE_HOST = "grafana-db-0.grafana-db:5432"
      //GF_DATABASE_SERVICE - using for name postgres in module postgres
      GF_DATABASE_SERVICE        = "grafana-db"
      GF_DATABASE_NAME           = "grafana"
      GF_AUTH_LDAP_ENABLED       = "true"
      GF_AUTH_LDAP_CONFIG_FILE   = "/etc/grafana/ldap/ldap.toml"
      GF_AUTH_LDAP_ALLOW_SIGN_UP = "true"
    }
    env_secret = {
      GF_SECURITY_ADMIN_USER     = var.grafana_admin_user
      GF_DATABASE_USER           = var.grafana_admin_user
      GF_SECURITY_ADMIN_PASSWORD = var.grafana_admin_password
      GF_DATABASE_PASSWORD       = var.grafana_admin_password
    }
    //grafana cert's files for https
    ssl_data = {
      "grafana.pem" = file("${var.path_secrets}/grafana.pem")
      "grafana.key" = file("${var.path_secrets}/grafana.key")
    }
    dashboards_map = {
      template-jmx        = { folder = "main" }
      template-os         = { folder = "main" }
      template-kamon      = { folder = "main" }
      node-os             = { folder = "main" }
      node-jmx            = { folder = "main" }
      node-win            = { folder = "main" }
      service-hbase       = { folder = "services" }
      service-hdfsgw      = { folder = "services" }
      service-hdfs        = { folder = "services" }
      service-hive        = { folder = "services" }
      service-impala      = { folder = "services" }
      service-jenkins     = { folder = "services" }
      service-kafka       = { folder = "services" }
      service-ldap        = { folder = "services" }
      service-oozie       = { folder = "services" }
      service-sentry      = { folder = "services" }
      service-spark       = { folder = "services" }
      service-yarn        = { folder = "services" }
      service-zookeeper   = { folder = "services" }
      service-yarn-l2     = { folder = "services" }
      service-yarn-l3     = { folder = "services" }
      service-yarn-rm-app = { folder = "services" }
      service-yarn-rm-l2  = { folder = "services" }
    }
    config_maps_list = [
      {
        map_name = "config-provisioning-plugins"
        map_path = "/etc/grafana/provisioning/plugins"
        map_data = {
          "plugins.yml" = file("${var.path_configs}/grafana-plugins.yml")
        }
      },
      {
        map_name = "config-provisioning-dashboards"
        map_path = "/etc/grafana/provisioning/dashboards"
        map_data = {
          "dashboards.yml" = file("${var.path_configs}/grafana-dashboards.yml")
        }
      },
    ]

    secret_maps_list = [
      {
        map_name = "config-provisioning-datasources"
        map_path = "/etc/grafana/provisioning/datasources"
        map_data = {
          "datasources.yml" = templatefile("${var.path_configs}/grafana-datasources.yml", {
            prometheus_os_host         = var.prometheus_os_host
            prometheus_os_user         = var.prometheus_os_user
            prometheus_os_password     = var.prometheus_os_password
            prometheus_container_port  = var.prometheus_container_port
            thanos_query_frontend_name = var.thanos_query_frontend_name
            elasticsearch_url          = "http://${var.elasticsearch.host}:${var.elasticsearch.port}"
          })
        }
      },
      {
        map_name = "config-ldap"
        map_path = "/etc/grafana/ldap"
        map_data = {
          "u_grafana.pem" = file("${var.path_secrets}/u_grafana.pem")
          "u_grafana.key" = file("${var.path_secrets}/u_grafana.key")
          "ldap.toml" = templatefile("${var.path_configs}/grafana-ldap.toml", {
            grafana_ldap_host          = var.grafana_ldap_host
            grafana_ldap_bind_user     = var.grafana_ldap_bind_user
            grafana_ldap_bind_suffix   = var.grafana_ldap_bind_suffix
            grafana_ldap_bind_password = var.grafana_ldap_bind_password
          })
        }
      }
    ]
  }
}
