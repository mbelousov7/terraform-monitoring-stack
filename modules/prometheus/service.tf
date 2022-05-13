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

resource "kubernetes_service" "service-sidecar" {
  metadata {
    name      = "${var.name}-sidecar"
    namespace = var.namespace
    labels = {
      name   = var.name
      module = "sidecar"
    }
  }
  spec {
    selector         = local.labels
    session_affinity = var.session_affinity
    type             = var.service_type
    port {
      name        = "sidecar-grpc"
      port        = var.container_port_grpc
      protocol    = "TCP"
      target_port = var.container_port_grpc
    }
    port {
      name        = "sidecar-http"
      port        = 10092
      protocol    = "TCP"
      target_port = 10092
    }
  }
}
