resource "kubernetes_secret" "secret" {
  for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
  metadata {
    name = "${var.name}-${each.value.secret_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.secret_data
}
