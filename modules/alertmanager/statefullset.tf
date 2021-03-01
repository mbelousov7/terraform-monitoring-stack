resource "kubernetes_stateful_set" "alertmanager" {

  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = local.labels
  }

  spec {
    pod_management_policy = var.pod_management_policy
    replicas = var.replicas
    service_name = var.name

    selector {
      match_labels = local.labels
    }

    update_strategy {
      type = var.update_strategy
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
                  key = "name"
                  operator = "In"
                  values = [ var.name ]
                }
              }
            }
          }
        }

        container {
          name  = var.name
          image = var.container_image
          image_pull_policy = var.image_pull_policy

          args = concat([
            "--config.file=${var.configPath}/alertmanager.yml",
            "--storage.path=${var.dataPath}",
            "--cluster.listen-address=0.0.0.0:${var.cluster_port}",
            "--web.listen-address=0.0.0.0:${var.container_port}",
            "--web.route-prefix=/",
            "--cluster.peer-timeout=45s",
            #"--cluster.peer=${var.name}-0.${var.name}-cluster.${var.namespace}.${var.dns_path_for_config}:${var.cluster_port}",
            #"--cluster.peer=${var.name}-1.${var.name}-cluster.${var.namespace}.${var.dns_path_for_config}:${var.cluster_port}",
            #"--cluster.peer=${var.name}-2.${var.name}-cluster.${var.namespace}.${var.dns_path_for_config}:${var.cluster_port}",
            "--log.level=info",
            "--data.retention=${var.retentionTime}"
          ],
          local.arg_list
          )
          port {
            container_port = var.container_port
            name = "http"
          }

          port {
            container_port = var.cluster_port
            name = "cluster"
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
            timeout_seconds = var.liveness_probe.timeout_seconds
            period_seconds = var.liveness_probe.period_seconds
            failure_threshold = var.liveness_probe.failure_threshold
            http_get {
              path = "/-/healthy"
              scheme = "HTTP"
              port = var.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds = var.readiness_probe.timeout_seconds
            period_seconds = var.readiness_probe.period_seconds
            failure_threshold = var.readiness_probe.failure_threshold
            http_get {
              path = "/-/ready"
              scheme = "HTTP"
              port = var.container_port
            }
          }

          volume_mount {
              mount_path = var.dataPath
              name       = "storage-volume"
          }

          volume_mount {
              mount_path = var.configPath
              name       = "alertmanager-config"
              read_only = true
          }

          dynamic "volume_mount" {
            for_each = {for map in local.config_maps_list:  map.map_name => map if can(map.map_name)}
            content {
              mount_path  = volume_mount.value.map_path
              name = volume_mount.value.map_name
              read_only = true
            }
          }
          dynamic "volume_mount" {
            for_each = {for map in local.secret_maps_list:  map.map_name => map if can(map.map_name)}
            content {
              mount_path  = volume_mount.value.map_path
              name = volume_mount.value.map_name
              read_only = true
            }
          }
        }


        container {
          name  = var.reloader_sidecar_config.name
          image = var.reloader_container_image
          image_pull_policy = var.image_pull_policy

          args = [
            "--volume-dir=${var.configPath}",
            "--webhook-method=POST",
            "--webhook-status-code=200",
            "--webhook-retries=3",
            "--webhook-url=http://localhost:${var.container_port}/-/reload",
          ]

          resources {
            limits {
              cpu    = var.reloader_sidecar_config.container_resources.limits_cpu
              memory = var.reloader_sidecar_config.container_resources.limits_memory
            }
            requests {
              cpu    = var.reloader_sidecar_config.container_resources.requests_cpu
              memory = var.reloader_sidecar_config.container_resources.requests_memory
            }
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds = var.liveness_probe.timeout_seconds
            period_seconds = var.liveness_probe.period_seconds
            failure_threshold = var.liveness_probe.failure_threshold
            http_get {
              path = "/metrics"
              scheme = "HTTP"
              port = var.reloader_sidecar_config.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds = var.readiness_probe.timeout_seconds
            period_seconds = var.readiness_probe.period_seconds
            failure_threshold = var.readiness_probe.failure_threshold
            http_get {
              path = "/metrics"
              scheme = "HTTP"
              port = var.reloader_sidecar_config.container_port
            }
          }

          volume_mount {
              mount_path = var.configPath
              name       = "alertmanager-config"
              read_only = true
          }

        }

        volume {
          name = "storage-volume"
          empty_dir {}
        }

        volume {
          name = "alertmanager-config"
          secret {
            secret_name = "${var.name}-config"
            default_mode = "0644"
          }
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
