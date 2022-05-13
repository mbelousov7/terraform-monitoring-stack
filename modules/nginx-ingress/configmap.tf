resource "kubernetes_config_map" "nginx-config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  data = merge({
    for item in local.server_map :
    "${index(local.server_map, item)}-${item.key}" => item.value
    },
    {
      "ingress.conf" = templatefile("${path.module}/configs/ingress.conf.tmpl", {})
  })
}

resource "kubernetes_config_map" "kerberos_config" {
  for_each = { for config in var.kerberos_config : config.config_name => config if can(config.config_name) }
  metadata {
    name      = "${var.name}-${each.value.config_name}"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.config_data
}
