module "pushgateway" {
  #for_each = {for pushgateway in local.pushgateway_list:  pushgateway.name => pushgateway}
  for_each                   = local.pushgateway_map
  source                     = "../../../modules/pushgateway"
  namespace                  = var.namespace
  name                       = each.key
  container_image            = var.pushgateway_container_image
  container_port             = var.pushgateway_container_port
  container_resources        = lookup(local.container_resources_pushgateway, var.env)
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
}

locals {
  pushgateway_map = {
    pushgateway = {
      app_port = var.pushgateway_container_port
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }
}
