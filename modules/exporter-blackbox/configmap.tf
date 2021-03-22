resource "kubernetes_config_map" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  data = {
    "config.yml" = file("${path.module}/files/blackbox.yml")
  }
}
