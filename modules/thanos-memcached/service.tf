resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector         = local.labels
    session_affinity = var.session_affinity
    cluster_ip       = var.service_cluster_ip
    type             = var.service_type
    port {
      name        = "memcached"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
    port {
      name        = "metrics"
      port        = var.container_port_metrics
      protocol    = "TCP"
      target_port = var.container_port_metrics
    }
  }
}
