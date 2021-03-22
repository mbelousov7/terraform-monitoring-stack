resource "kubernetes_secret" "secret" {
  for_each = { for secret in local.secret_maps_list : secret.map_name => secret if can(secret.map_name) }
  metadata {
    name      = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_secret" "grafana-secret-env" {
  metadata {
    name      = "${var.name}-env"
    namespace = var.namespace
    labels    = local.labels
  }

  data = var.env_secret

  #type = "kubernetes.io/basic-auth"
}

resource "kubernetes_secret" "ssl-secret" {
  count = var.ssl_data != {} ? 1 : 0
  metadata {
    name      = "${var.name}-ssl"
    namespace = var.namespace
    labels    = local.labels
  }
  data = var.ssl_data
}
