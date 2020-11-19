locals {
  //configs for multiple independed prometheuses
  prometheus_list = [
    {
      name = "prometheus-infra"
      container_resources_requests_cpu = "200m"
      container_resources_limits_cpu = "400m"
      container_resources_requests_memory = "512Mi"
      container_resources_limits_memory = "1024Mi"
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
