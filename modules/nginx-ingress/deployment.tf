resource "kubernetes_deployment" "nginx-ingress" {
  timeouts {
    create = "5m"
    delete = "2m"
    update = "7m"
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas                  = var.replicas
    progress_deadline_seconds = 600

    strategy {
      type = var.strategy
    }

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels      = local.labels
        annotations = local.annotations
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

        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name

          port {
            container_port = var.container_port
            protocol       = "TCP"
            name           = "http"
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
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            http_get {
              path   = "/50x.html"
              scheme = "HTTPS"
              port   = var.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            http_get {
              path   = "/50x.html"
              scheme = "HTTPS"
              port   = var.container_port
            }
          }

          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "config-volume"
            read_only  = true
          }

          volume_mount {
            mount_path = "/etc/nginx/password"
            name       = "password-volume"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = { for server, config in var.server_map : server => config if can(config.ssl_data) }
            content {
              mount_path = "/etc/nginx/ssl/${volume_mount.key}"
              name       = "ssl-${volume_mount.key}"
              read_only  = true
            }
          }

        }

        volume {
          name = "config-volume"
          secret {
            secret_name  = "${var.name}-config-secret"
            default_mode = "0400"
          }
        }

        volume {
          name = "password-volume"
          secret {
            secret_name  = "${var.name}-password-secret"
            default_mode = "0644"
          }
        }

        dynamic "volume" {
          for_each = { for server, config in var.server_map : server => config if can(config.ssl_data) }
          content {
            name = "ssl-${volume.key}"
            secret {
              secret_name  = "${var.name}-ssl-${volume.key}"
              default_mode = "0644"
            }
          }
        }
      }
    }
  }
}
