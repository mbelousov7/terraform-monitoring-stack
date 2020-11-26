resource "kubernetes_config_map" "rules" {
  metadata {
    name = "${var.name}-rules"
    namespace = var.namespace
    labels = local.labels
  }
  data = var.rules_data
}
