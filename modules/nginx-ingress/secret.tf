resource "kubernetes_secret" "nginx-config-secret" {
  metadata {
    name      = "${var.name}-config-secret"
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    "default.conf" = templatefile("${path.module}/configs/default.conf.tmpl", {
      container_port = var.container_port
      })
    "server.conf" = templatefile("${path.module}/configs/server-${var.auth_type}.conf.tmpl", {
      server_map = var.server_map
      container_port = var.container_port
      namespace   = var.namespace
      dns_path_for_config = var.dns_path_for_config
    })
    "ingress.conf" = templatefile("${path.module}/configs/ingress.conf.tmpl", {})
    "ssl.key" = templatefile("${path.module}/configs/sslkey.tmpl", {})
    "ssl.crt" = templatefile("${path.module}/configs/sslcrt.tmpl", {})

  }
  type = "Opaque"
}

resource "kubernetes_secret" "nginx-ssl-secret" {
  for_each = { for server, config in var.server_map : server => config if can(config.ssl_data)}
  metadata {
    name = "${var.name}-ssl-${each.key}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.ssl_data
}

resource "kubernetes_secret" "nginx-password-secret" {
  metadata {
    name      = "${var.name}-password-secret"
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    ".htpasswd" = templatefile("${path.module}/configs/.htpasswd", {
      nginx_users_map = var.nginx_users_map
      })
  }
  type = "Opaque"
}
