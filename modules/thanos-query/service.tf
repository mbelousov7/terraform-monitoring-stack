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
      name        = "http"
      port        = var.container_port
      protocol    = "TCP"
      target_port = var.container_port
    }
  }
}

resource "kubernetes_service" "service_sidecars" {
  count = var.service_sidecars.name == "sidecars" ? 1 : 0
  metadata {
    name      = "${var.name}-sidecars"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector         = var.service_sidecars.selector
    session_affinity = var.service_sidecars.session_affinity
    type             = var.service_sidecars.type
    cluster_ip       = var.service_sidecars.cluster_ip
    port {
      name        = "grpc"
      port        = var.container_port_grpc
      protocol    = "TCP"
      target_port = var.container_port_grpc
    }
  }
}
