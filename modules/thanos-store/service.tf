resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector         = local.labels
    session_affinity = var.session_affinity
    type             = var.service_type
    port {
      name        = "grpc"
      port        = var.container_port_grpc
      protocol    = "TCP"
      target_port = var.container_port_grpc
    }
    port {
      name        = "http"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}
