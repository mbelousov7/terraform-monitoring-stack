locals {
  //configs for multiple independed prometheuses
  alertmanager_list = [
    {
      name = "alertmanager-a"
      name_replica = "alertmanager-b"
      app_port = 9093
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.crt" = file("./secrets/alertmanager-a.crt")
        "ssl_certificate_key.key" = file("./secrets/alertmanager-a.key")
      }
      config_maps_list = [
      ]
      secret_maps_list = [
        {
          map_name = "config-main"
          map_path = "/etc/alertmanager"
          map_data = {
            "alertmanager.yml" = file("./alertmanager/alertmanager.yml")
          }
        }
      ]
    },
    {
      name = "alertmanager-b"
      name_replica = "alertmanager-a"
      app_port = 9093
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.crt" = file("./secrets/alertmanager-a.crt")
        "ssl_certificate_key.key" = file("./secrets/alertmanager-a.key")
      }
      config_maps_list = [
      ]
      secret_maps_list = [
        {
          map_name = "config-main"
          map_path = "/etc/alertmanager"
          map_data = {
            "alertmanager.yml" = file("./alertmanager/alertmanager.yml")
          }
        }
      ]
    }
  ]
}
