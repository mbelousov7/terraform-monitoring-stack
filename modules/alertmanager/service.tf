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
      name        = "alertmngr-peer"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
    port {
      name        = "alertmngr-cl"
      port        = var.cluster_port
      protocol    = "TCP"
      target_port = var.cluster_port
    }
  }
}
