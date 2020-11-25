resource "kubernetes_deployment" "pushgateway" {
  timeouts {
    create = "5m"
    delete = "2m"
    update = "5m"
  }

  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = local.labels
  }

  spec {
    replicas = var.replicas
    progress_deadline_seconds = 600

    strategy {
      type = var.strategy
    }

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        container {
          image = var.container_image
          name  = var.name
          args = [ ]

          port {
            container_port = var.container_port
            name = "pushgateway"
          }

          resources {
            limits {
              cpu    = var.container_resources_limits_cpu
              memory = var.container_resources_limits_memory
            }
            requests {
              cpu    = var.container_resources_requests_cpu
              memory = var.container_resources_requests_memory
            }
          }

          liveness_probe {
            timeout_seconds = var.liveness_probe_timeout_seconds
            period_seconds = var.liveness_probe_period_seconds
            failure_threshold = var.liveness_probe_failure_threshold
            exec {
              command = ["curl", "${var.name}:${var.container_port}"]
            }
          }

        }

      }
    }
  }
}
