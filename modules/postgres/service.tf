resource "kubernetes_service" "service" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = local.labels
    type = var.service_type
    port {
      name        = "postgres"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}