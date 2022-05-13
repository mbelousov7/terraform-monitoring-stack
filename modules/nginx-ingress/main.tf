terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  labels = merge(
    { name = var.name },
    { module = "nginx-ingress" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_config_map.nginx-config.data,
      kubernetes_secret.nginx-password-secret.data,
    )))
    config_server_map_sha1 = sha1(jsonencode(merge(
      var.server_map,
    )))
    config_kerberos_sha1 = can(var.kerberos_config.config_name) ? sha1(jsonencode(merge(
      var.kerberos_config,
    ))) : "none"

    config_keytab_sha1 = can(var.kerberos_keytab.config_name) ? sha1(jsonencode(merge(
      var.kerberos_keytab,
    ))) : "none"
  }

  server_map = flatten([
    for server_key, server_value in var.server_map : [{
      key = "${server_key}.conf"
      value = templatefile("${path.module}/configs/server-template.conf.tmpl", {
        server_name         = server_value.name != null ? server_value.name : server_key
        server              = server_value
        container_port      = var.container_port
        namespace           = var.namespace
        dns_path_for_config = var.dns_path_for_config
        route_suffix        = var.route_suffix
        kerberos_config     = contains(keys(server_value.auth_locations), "kerberos") ? var.kerberos_config : null
      })
    }]
  ])

}
