resource "kubernetes_deployment" "nginx-ingress" {
  timeouts {
    create = "2m"
    delete = "2m"
    update = "2m"
  }

  metadata {
    name        = var.app_name
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
          name  = var.app_name
          port {
            container_port = var.container_port
            protocol = "TCP"
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

          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "config-volume"
          }

          volume_mount {
            mount_path = "/etc/nginx/password"
            name       = "password-volume"
          }

          dynamic "volume_mount" {
            for_each = {for ssl in var.server_list:  ssl.app_name => ssl if can(ssl.ssl)}
            content {
              mount_path  = "/etc/nginx/ssl/${each.value.app_name}"
              name = "ssl-${each.value.app_name}"
            }
          }

        }

        volume {
          name = "config-volume"
          secret {
            secret_name = "${var.app_name}-config-secret"
            default_mode = "0400"
          }
        }

        volume {
          name = "password-volume"
          secret {
            secret_name = "${var.app_name}-password-secret"
            default_mode = "0644"
          }
        }

        dynamic "volume" {
          for_each = {for ssl in var.server_list:  ssl.app_name => ssl if can(ssl.ssl)}
          content {
            name = "ssl-${each.value.app_name}"
            secret {
              secret_name = "${var.app_name}-ssl-${each.value.app_name}"
              default_mode = "0644"
            }
          }
        }
      }
  }
 }
}
