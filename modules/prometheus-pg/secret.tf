resource "kubernetes_secret" "secret" {
  for_each = {for secret in local.secret_maps_list:  secret.map_name => secret if can(secret.map_name)}
  metadata {
    name = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_secret" "pg-adapter" {
  metadata {
    name = "${var.name}-${var.pg_adapter_config.name}-env"
    namespace = var.namespace
    labels = local.labels
  }
  data = var.pg_adapter_config.env_secret
}
