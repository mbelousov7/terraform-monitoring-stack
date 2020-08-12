resource "kubernetes_service" "service" {
  metadata {
    name = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = var.labels
    type = "ClusterIP"
    port {
      name        = "http"
      port        = 9090
      protocol    = "TCP"
      target_port = 9090
    }
  }
}
