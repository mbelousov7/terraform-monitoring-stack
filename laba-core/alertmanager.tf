module "alertmanager" {
  for_each = {for alertmanager in local.alertmanager_list:  alertmanager.name => alertmanager}
  source = "../modules/alertmanager"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  name_replica  = each.value.name_replica
  container_image = var.alertmanager_container_image
  container_port = var.alertmanager_container_port
  config_maps_list = lookup(each.value, "config_maps_list", [])
  secret_maps_list = lookup(each.value, "secret_maps_list", [])
  container_resources_requests_cpu = "100m"
  container_resources_limits_cpu = "150m"
  container_resources_requests_memory = "100Mi"
  container_resources_limits_memory = "128Mi"
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

locals {
  //configs for multiple independed prometheuses
  alertmanager_list = [
    {
      name = "alertmanager-a"
      name_replica = "alertmanager-b"
      app_port = var.alertmanager_container_port
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
