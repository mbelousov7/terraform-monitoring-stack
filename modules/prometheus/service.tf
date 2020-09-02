resource "kubernetes_service" "service" {
  metadata {
    name = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = local.labels
    type = var.service_type
    port {
      name        = "prometheus"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}
