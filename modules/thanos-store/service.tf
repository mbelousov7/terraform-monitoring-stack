resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector         = local.labels
    session_affinity = var.session_affinity
    //cluster_ip       = var.service_cluster_ip
    type = var.service_type
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

resource "kubernetes_service" "service-headless" {
  metadata {
    name      = "${var.name}-headless"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector         = local.labels
    session_affinity = var.session_affinity
    cluster_ip       = "None"
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
