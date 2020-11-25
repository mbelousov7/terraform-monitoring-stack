resource "kubernetes_deployment" "alertmanager" {
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
            "--config.file=${var.configPath}/alertmanager.yml",
            "--storage.path=${var.dataPath}",
            "--cluster.listen-address=:${var.cluster_port}",
            "--web.listen-address=:${var.container_port}",
            "--web.route-prefix=/",
            "--cluster.peer-timeout=45s",
            "--cluster.peer=${var.name}:${var.cluster_port}",
            "--cluster.peer=${var.name_replica}:${var.cluster_port}",
            "--log.level=info",
            "--data.retention=${var.retentionTime}"
          ]

          port {
            container_port = var.container_port
            name = "alertmngr-peer"
          }

          port {
            container_port = var.cluster_port
            name = "alertmngr-cl"
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
