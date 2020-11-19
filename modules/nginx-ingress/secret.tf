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
      server_list = var.server_list
      container_port = var.container_port
      namespace   = var.namespace
      resolver = var.resolver
      route_path_for_config = var.route_path_for_config
      //app_port = var.app_port
      })
    "ingress.conf" = templatefile("${path.module}/configs/ingress.conf.tmpl", {
      resolver = var.resolver
      })

  }
  type = "Opaque"
}

resource "kubernetes_secret" "nginx-ssl-secret" {
  for_each = {for ssl in var.server_list:  ssl.name => ssl if can(ssl.ssl_data)}
  metadata {
    name = "${var.name}-ssl-${each.value.name}"
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
      user = var.user
      password = var.password
      })
  }
  type = "Opaque"
}
