locals {
  pushgateway_list = [
    {
      name = "pushgateway"
      app_port = 9091
      container_resources_requests_cpu = "50m"
      container_resources_limits_cpu = "100m"
      container_resources_requests_memory = "54Mi"
      container_resources_limits_memory = "128Mi"
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.crt" = file("./secrets/pushgateway.crt")
        "ssl_certificate_key.key" = file("./secrets/pushgateway.key")
      }
    },
  ]
}
