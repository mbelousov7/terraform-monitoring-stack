resource "kubernetes_secret" "prometheus-secret" {
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
