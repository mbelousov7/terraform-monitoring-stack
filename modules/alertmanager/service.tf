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

    port {
      name        = "cluster"
      port        = var.cluster_port
      protocol    = "TCP"
      target_port = var.cluster_port
    }

  }
}

/*
resource "kubernetes_service" "service-cluster" {
  metadata {
    name = "${var.name}-cluster"
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    selector = local.labels
    session_affinity = var.session_affinity
    type = var.service_type
    port {
      name        = "cluster"
      port        = var.cluster_port
      protocol    = "TCP"
      target_port = var.cluster_port
    }
  }
}
*/
