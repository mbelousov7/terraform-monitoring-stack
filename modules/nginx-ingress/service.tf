resource "kubernetes_service" "service" {
  metadata {
    name = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = local.labels
    type = "LoadBalancer"
    port {
      name        = "nginx-ingress"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}