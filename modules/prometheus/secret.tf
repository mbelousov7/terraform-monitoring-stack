resource "kubernetes_secret" "prometheus-secret" {
  metadata {
    name      = "prometheus-secret"
    namespace = var.kubernetes_namespace
  }
  data = {
    username = "admin"
    password = "P4ssw0rd"
  }
  type = "Opaque"
}
