resource "kubernetes_deployment" "pushgateway" {
  timeouts {
    create = "3m"
    delete = "2m"
    update = "3m"
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas                  = 1 #var.replicas
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
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              }
            }
          }
        }

        automount_service_account_token = false

        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args              = []

          port {
            container_port = var.container_port
            name           = "http"
          }

          security_context {
            read_only_root_filesystem = true
          }

          resources {
            limits = {
              cpu    = var.container_resources.limits_cpu
              memory = var.container_resources.limits_memory
            }
            requests = {
              cpu    = var.container_resources.requests_cpu
              memory = var.container_resources.requests_memory
            }
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            http_get {
              path   = "/-/healthy"
              scheme = "HTTP"
              port   = var.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            http_get {
              path   = "/-/ready"
              scheme = "HTTP"
              port   = var.container_port
            }
          }
        }

        container {
          name              = var.cleaner_sidecar_config.name
          image             = var.pushgateway_cleaner_container_image
          image_pull_policy = var.image_pull_policy

          args = [
            "-address=http://localhost:${var.container_port}",
            "-debug",
            "-ttl=15m"
          ]

          security_context {
            read_only_root_filesystem = true
          }

          resources {
            limits = {
              cpu    = var.cleaner_sidecar_config.container_resources.limits_cpu
              memory = var.cleaner_sidecar_config.container_resources.limits_memory
            }
            requests = {
              cpu    = var.cleaner_sidecar_config.container_resources.requests_cpu
              memory = var.cleaner_sidecar_config.container_resources.requests_memory
            }
          }
        }


      }
    }
  }
}
