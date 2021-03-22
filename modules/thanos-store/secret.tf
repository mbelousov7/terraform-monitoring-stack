resource "kubernetes_secret" "config-s3" {
  metadata {
    name      = "${var.name}-config-s3"
    namespace = var.namespace
    labels    = local.labels
  }
  data = var.config_s3
}
