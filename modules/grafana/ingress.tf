resource "kubernetes_ingress" "nginx-ingress" {
  count = var.expose == "ingress" ? 1 : 0
  metadata {
    name      = "${var.name}-ingress"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    rule {
      host = "${var.name}.local"
      http {
        path {
          backend {
            service_name = var.name
            service_port = var.container_port
          }
        }
      }
    }
  }
}
