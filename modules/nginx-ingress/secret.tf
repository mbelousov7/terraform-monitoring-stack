resource "kubernetes_secret" "nginx-config-secret" {
  metadata {
    name      = "${var.app_name}-config-secret"
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    "default.conf" = templatefile("${path.module}/configs/default.conf.tmpl", {
      container_port = var.container_port
      })
    "server.conf" = templatefile("${path.module}/configs/server.conf.tmpl", {
      server_list = var.server_list
      container_port = var.container_port
      })
    "ingress.conf" = templatefile("${path.module}/configs/ingress.conf.tmpl", {
      resolver = var.resolver
      })

  }
  type = "Opaque"
}

resource "kubernetes_secret" "nginx-password-secret" {
  metadata {
    name      = "${var.app_name}-password-secret"
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
