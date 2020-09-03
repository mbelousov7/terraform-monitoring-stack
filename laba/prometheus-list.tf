locals {
  prometheus_list = [
    {
      app_name = "prometheus-cdh"
      container_resources_requests_cpu = "200m"
      container_resources_limits_cpu = "400m"
      container_resources_requests_memory = "512Mi"
      container_resources_limits_memory = "1024Mi"
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.crt" = file("./secrets/nginx.crt")
        "ssl_certificate_key.key" = file("./secrets/nginx.key")
      }
      config_maps_list = [
        {
          mount_path = "/etc/prometheus"
          name = "config-prometheus-volume"
          config_map_name = "config-prometheus"
          config_map_data = {
            "prometheus.yaml" = file("./prometheus-cdh/prometheus.yaml")
          }
        },
        {
          mount_path = "/etc/prometheus/file_sd_config"
          name = "config-file-sd-config-volume"
          config_map_name = "config-file-sd-config"
          config_map_data = {
            "file_sd_config_test.json" = file("./prometheus-cdh/file_sd_config/file_sd_config_test.json")
            "file_sd_config_test1.json" = file("./prometheus-cdh/file_sd_config/file_sd_config_test1.json")
          }
        },
        {
          mount_path = "/etc/prometheus/rules"
          name = "config-rules-volume"
          config_map_name = "config-rules"
          config_map_data = {
            "rules.yaml" = file("./prometheus-cdh/rules/rules.yaml")
          }
        }
      ]
      secret_maps_list = [
        {
          mount_path = "/etc/prometheus/secrets"
          name = "config-secret-volume"
          secret_name = "prometheus-secret"
          secret_data = {
            ".password" = var.monitoring_password
          }
        }
      ]
    },
    {
      app_name = "prometheus-sdp"
      container_resources_requests_cpu = "200m"
      container_resources_limits_cpu = "400m"
      container_resources_requests_memory = "512Mi"
      container_resources_limits_memory = "1024Mi"
      ssl_data = {
        "ssl_certificate.crt" = file("./secrets/nginx.crt")
        "ssl_certificate_key.key" = file("./secrets/nginx.key")
      }
      config_maps_list = [
        {
          mount_path = "/etc/prometheus"
          name = "config-prometheus-volume"
          config_map_name = "config-prometheus"
          config_map_data = {
            "prometheus.yaml" = file("./prometheus-cdh/prometheus.yaml")
          }
        },
        {
          mount_path = "/etc/prometheus/file_sd_config"
          name = "config-file-sd-config-volume"
          config_map_name = "config-file-sd-config"
          config_map_data = {
            "file_sd_config_test.json" = file("./prometheus-cdh/file_sd_config/file_sd_config_test.json")
          }
        },
        {
          mount_path = "/etc/prometheus/rules"
          name = "config-rules-volume"
          config_map_name = "config-rules"
          config_map_data = {
            "rules.yaml" = file("./prometheus-cdh/rules/rules.yaml")
          }
        }
      ]
      secret_maps_list = [
        {
          mount_path = "/etc/prometheus/secrets"
          name = "config-secret-volume"
          secret_name = "prometheus-secret"
          secret_data = {
            ".password" = var.monitoring_password
          }
        }
      ]
    }
  ]
}
