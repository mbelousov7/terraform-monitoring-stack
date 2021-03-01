resource "kubernetes_secret" "secret" {
  for_each = {for secret in local.secret_maps_list:  secret.map_name => secret if can(secret.map_name)}
  metadata {
    name = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_secret" "config" {
  metadata {
    name = "${var.name}-config"
    namespace = var.namespace
    labels = local.labels
  }

  data = var.config_data

}

/*resource "kubernetes_secret" "prometheus-secret" {
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
*/
