module "pushgateway" {
  for_each = {for pushgateway in local.pushgateway_list:  pushgateway.name => pushgateway}
  source = "../modules/pushgateway"
  depends_on = [ kubernetes_namespace.monitoring ]
  namespace = var.namespace
  name = each.value.name
  container_image = "prom/pushgateway:latest"
  container_port = var.pushgateway_container_port
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "50m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "90m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "64Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "100Mi")
  expose = "none"
  nginx_ingress_service_name = "nginx-ingress"
}

locals {
  pushgateway_list = [
    {
      name = "pushgateway"
      app_port = var.pushgateway_container_port
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
