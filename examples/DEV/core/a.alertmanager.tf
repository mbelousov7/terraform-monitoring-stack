module "alertmanager" {
  #for_each = {for alertmanager in local.alertmanager_list:  alertmanager.name => alertmanager}
  for_each                   = local.alertmanager_map
  source                     = "../../../modules/alertmanager"
  namespace                  = var.namespace
  name                       = each.key
  container_image            = var.alertmanager_container_image
  container_resources        = lookup(local.container_resources_alertmanager, var.env)
  reloader_container_image   = var.reloader_container_image
  replicas                   = var.replicas_statefulset
  container_port             = var.alertmanager_container_port
  config_data                = each.value.config_data
  expose                     = var.expose
  route_suffix               = var.route_suffix
  nginx_ingress_service_name = var.nginx_ingress_service_name
}

locals {
  alertmanager_map = {
    alertmanager = {
      name     = var.alertmanager_name
      app_port = var.alertmanager_container_port
      config_data = {
        "alertmanager.yml" = templatefile("${var.path_configs}/alertmanager-${var.env}.yml", {
          alertmanager_smtp_smarthost     = var.alertmanager_smtp_smarthost
          alertmanager_smtp_from          = var.alertmanager_smtp_from
          alertmanager_smtp_auth_username = var.alertmanager_smtp_auth_username
          alertmanager_smtp_auth_password = var.alertmanager_smtp_auth_password
          alertmanager_receivers_email    = var.alertmanager_receivers_email
        })
      }
      ssl_data = {
        #cert and key for https configuration in nginx-ingress
        "ssl_certificate.pem"     = file("${var.path_secrets}/tls.pem")
        "ssl_certificate_key.key" = file("${var.path_secrets}/tls.key")
      }
    }
  }
}
