resource "kubernetes_deployment" "prometheus" {
  timeouts {
    create = "2m"
    delete = "2m"
    update = "3m"
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
          args = [
            "--web.enable-lifecycle",
            "--web.enable-admin-api",
            "--config.file=${var.configPath}/prometheus.yaml",
            "--web.listen-address=:${var.container_port}",
            "--storage.tsdb.path=${var.dataPath}",
            "--storage.tsdb.retention.time=${var.retentionTime}",
            "--storage.tsdb.retention.size=${var.retentionSize}"
          ]
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
              mount_path = var.dataPath
              name       = "storage-volume"
          }

          dynamic "volume_mount" {
            for_each = local.config_maps_list
            content {
              mount_path  = volume_mount.value.mount_path
              name = volume_mount.value.name
            }
          }
          dynamic "volume_mount" {
            for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
            content {
              mount_path  = volume_mount.value.mount_path
              name = volume_mount.value.name
            }
          }
        }

        volume {
          name = "storage-volume"
          empty_dir {}
        }

        dynamic "volume" {
          for_each = local.config_maps_list
          content {
            name = volume.value.name
            config_map {
              name = "${var.name}-${volume.value.config_map_name}"
              default_mode = "0644"
            }
          }
        }
        dynamic "volume" {
          for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
          content {
            name = volume.value.name
            secret {
              secret_name = "${var.name}-${volume.value.secret_name}"
              default_mode = "0644"
            }
          }
        }
      }
  }
 }
}
