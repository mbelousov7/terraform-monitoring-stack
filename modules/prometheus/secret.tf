resource "kubernetes_secret" "secret" {
  for_each = { for secret in local.secret_maps_list : secret.map_name => secret if can(secret.map_name) }
  metadata {
    name      = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_secret" "s3-config" {
  //count = can(var.thanos_sidecar_config.config_s3) ?  1 : 0
  //for_each = can(var.thanos_sidecar_config.s3_data) ? var.thanos_sidecar_config.s3_data : {}
  for_each = { for config in var.thanos_sidecar_config : config.name => config if can(config.config_s3) }
  metadata {
    name      = "${var.name}-config-s3"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.config_s3
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

