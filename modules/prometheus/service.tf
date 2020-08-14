resource "kubernetes_service" "service" {
  metadata {
    name = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    #selector = {
    #  app = "prometheus-cdh-dc"
    #}
    selector = local.labels
    type = "ClusterIP"
    port {
      name        = "prometheus"
      port        = 9090
      protocol    = "TCP"
      target_port = 9090
    }
  }
}
