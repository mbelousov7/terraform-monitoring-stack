resource "kubernetes_deployment" "nginx-ingress" {
  timeouts {
    create = "2m"
    delete = "2m"
    update = "2m"
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
        annotations = {
          config_change = sha1(jsonencode(merge(
            kubernetes_secret.nginx-config-secret.data,
            kubernetes_secret.nginx-password-secret.data
          )))
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.name
          port {
            container_port = var.container_port
            protocol = "TCP"
            name = "nginx"
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

          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "config-volume"
          }

          volume_mount {
            mount_path = "/etc/nginx/password"
            name       = "password-volume"
          }

          dynamic "volume_mount" {
            for_each = {for ssl in var.server_list:  ssl.name => ssl  if can(ssl.ssl_data)}
            content {
              mount_path  = "/etc/nginx/ssl/${volume_mount.value.name}"
              name = "ssl-${volume_mount.value.name}"
            }
          }

        }

        volume {
          name = "config-volume"
          secret {
            secret_name = "${var.name}-config-secret"
            default_mode = "0400"
          }
        }

        volume {
          name = "password-volume"
          secret {
            secret_name = "${var.name}-password-secret"
            default_mode = "0644"
          }
        }

        dynamic "volume" {
          for_each = {for ssl in var.server_list:  ssl.name => ssl if can(ssl.ssl_data)}
          content {
            name = "ssl-${volume.value.name}"
            secret {
              secret_name = "${var.name}-ssl-${volume.value.name}"
              default_mode = "0644"
            }
          }
        }
      }
  }
 }
}
