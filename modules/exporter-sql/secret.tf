resource "kubernetes_secret" "config" {
  metadata {
    name = "${var.name}-config"
    namespace = var.namespace
    labels = local.labels
  }
  data = var.config_data
}

