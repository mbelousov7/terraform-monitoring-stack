resource "kubernetes_secret" "config-s3" {
  metadata {
    name      = "${var.name}-config-s3"
    namespace = var.namespace
    labels    = local.labels
  }
  data = var.config_s3
}

/*
resource "kubernetes_secret" "thanos-store-sa" {
  metadata {
    name      = "${var.name}-serviceaccount"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = "default"
    }
  }
  type = "kubernetes.io/service-account-token"
}
*/
