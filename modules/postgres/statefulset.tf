resource "kubernetes_stateful_set" "postgres" {

  depends_on = [
    kubernetes_service.service,
  ]
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = local.labels
  }

  spec {
    replicas = var.replicas
    pod_management_policy = var.pod_management_policy

    update_strategy {
      type = var.update_strategy
    }
    service_name = var.name

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
          image_pull_policy = var.image_pull_policy
          name  = var.name
          args = [ ]

          port {
            container_port = var.container_port
            name = "postgres"
          }

          env_from {
            secret_ref {
              name = "${var.name}-env"
            }
          }

          resources {
            limits {
              cpu    = var.container_resources.limits_cpu
              memory = var.container_resources.limits_memory
            }
            requests {
              cpu    = var.container_resources.requests_cpu
              memory = var.container_resources.requests_memory
            }
          }

          liveness_probe {
            timeout_seconds = var.liveness_probe.timeout_seconds
            period_seconds = var.liveness_probe.period_seconds
            failure_threshold = var.liveness_probe.failure_threshold
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            tcp_socket {
              port = var.container_port
            }
          }

          readiness_probe {
            timeout_seconds = var.readiness_probe.timeout_seconds
            period_seconds = var.readiness_probe.period_seconds
            failure_threshold = var.readiness_probe.failure_threshold
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            tcp_socket {
              port = var.container_port
            }
          }

        }

      }
    }
  }
}
