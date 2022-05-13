resource "kubernetes_secret" "nginx-ssl-secret" {
  for_each = { for server, config in var.server_map : server => config if can(config.ssl_data) }
  metadata {
    name      = "${var.name}-ssl-${each.key}"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.ssl_data
}

resource "kubernetes_secret" "nginx-password-secret" {
  metadata {
    name      = "${var.name}-password-secret"
    namespace = var.namespace
    labels    = local.labels
  }
  data = {
    ".htpasswd" = templatefile("${path.module}/configs/.htpasswd", {
      nginx_users_map = var.nginx_users_map
    })
  }
  type = "Opaque"
}

resource "kubernetes_secret" "kerberos_keytab" {
  for_each = { for config in var.kerberos_keytab : config.config_name => config if can(config.config_name) }
  metadata {
    name      = "${var.name}-${each.value.config_name}-secret"
    namespace = var.namespace
    labels    = local.labels
  }
  binary_data = each.value.config_binary_data
}
