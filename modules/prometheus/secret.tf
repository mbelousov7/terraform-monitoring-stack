resource "kubernetes_secret" "prometheus-secret" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    username = "admin"
    password = "P4ssw0rd"
  }
  type = "Opaque"
}

resource "kubernetes_secret" "secret" {
  for_each = {for secret in local.secret_maps_list:  secret.name => secret}
  metadata {
    name = "${var.app_name}-${each.value.secret_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.secret_data
}
