resource "kubernetes_service" "service" {
  count = var.service == true ? 1 : 0
  metadata {
    name = var.name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = local.labels
    type = var.service_type
    port {
      name        = "exporter-jmx"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}
