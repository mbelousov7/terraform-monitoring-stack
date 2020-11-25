resource "kubernetes_deployment" "prometheus" {
  #depends_on = [kubernetes_service_account.sa]
  timeouts {
    create = "4m"
    delete = "2m"
    update = "4m"
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
        service_account_name = var.service_account_name
        automount_service_account_token = var.automount_service_account_token
        container {
          image = var.container_image
          name  = var.name
          args = [
            "--web.enable-lifecycle",
            "--web.enable-admin-api",
            "--config.file=${var.configPath}/prometheus.yml",
            "--web.listen-address=:${var.container_port}",
            "--storage.tsdb.path=${var.dataPath}",
            "--storage.tsdb.retention.time=${var.retentionTime}",
            "--storage.tsdb.retention.size=${var.retentionSize}"
          ]

          port {
            container_port = var.container_port
            name = "prometheus"
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
              mount_path = var.dataPath
              name       = "storage-volume"
          }

          dynamic "volume_mount" {
            for_each = {for map in local.config_maps_list:  map.map_name => map if can(map.map_name)}
            content {
              mount_path  = volume_mount.value.map_path
              name = volume_mount.value.map_name
            }
          }
          dynamic "volume_mount" {
            for_each = {for map in local.secret_maps_list:  map.map_name => map if can(map.map_name)}
            content {
              mount_path  = volume_mount.value.map_path
              name = volume_mount.value.map_name
            }
          }
        }

        volume {
          name = "storage-volume"
          empty_dir {}
        }

        dynamic "volume" {
          for_each = {for map in local.config_maps_list:  map.map_name => map if can(map.map_name)}
          content {
            name = volume.value.map_name
            config_map {
              name = "${var.name}-${volume.value.map_name}"
              default_mode = "0644"
            }
          }
        }
        dynamic "volume" {
          for_each = {for map in local.secret_maps_list:  map.map_name => map if can(map.map_name)}
          content {
            name = volume.value.map_name
            secret {
              secret_name = "${var.name}-${volume.value.map_name}"
              default_mode = "0644"
            }
          }
        }

      }
  }
 }
}
