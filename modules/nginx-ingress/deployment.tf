resource "kubernetes_deployment" "nginx-ingress" {
  timeouts {
    create = "1m"
    delete = "1m"
    update = "1m"
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

          /*dynamic "volume_mount" {
            for_each = local.secret_volumes
            content {
              mount_path  = volume_mount.value.mount_path
              name = volume_mount.value.name
            }
          }*/

          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "config-volume"
          }

          volume_mount {
            mount_path = "/etc/nginx/password"
            name       = "password-volume"
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

        /*dynamic "volume" {
          for_each = local.secret_volumes
          content {
            name = volume.value.name
            secret_name {
              name = volume.value.config_map_name
              mode = 400
            }
          }
        }*/
      }
  }
 }
}
