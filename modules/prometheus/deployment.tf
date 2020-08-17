resource "kubernetes_deployment" "prometheus" {
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
      }

      spec {
        container {
          image = var.container_image
          name  = var.app_name
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

          volume_mount {
              mount_path = var.dataPath
              name       = "storage-volume"
          }

          dynamic "volume_mount" {
            for_each = local.configMap_volumes
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
          for_each = local.configMap_volumes
          content {
            name = volume.value.name
            config_map {
              name = volume.value.config_map_name
            }
          }
        }
      }
  }
 }
}
