resource "kubernetes_stateful_set" "alertmanager" {

  timeouts {
    create = "15m"
    delete = "5m"
    update = "15m"
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    pod_management_policy = var.pod_management_policy
    replicas              = var.replicas
    service_name          = "${var.name}-headless"

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
          name              = var.name
          image             = var.container_image
          image_pull_policy = var.image_pull_policy

          env {
            name = "POD_IP"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }
          security_context {
            read_only_root_filesystem = true
          }
          args = compact(concat([
            "--config.file=${var.configPath}/alertmanager.yml",
            "--storage.path=${var.dataPath}",
            "--cluster.listen-address=0.0.0.0:${var.cluster_port}",
            "--cluster.advertise-address=$(POD_IP):${var.cluster_port}",
            "--web.listen-address=0.0.0.0:${var.container_port}",
            "--web.route-prefix=/",
            "--cluster.peer-timeout=2m",
            "--cluster.gossip-interval=1000ms",
            "--cluster.pushpull-interval=1m0s",
            "--cluster.settle-timeout=1m",
            "--cluster.probe-timeout=5s",
            "--cluster.probe-interval=15s",
            "--log.level=info",
            "--data.retention=${var.retentionTime}"
            ],
            [for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}-headless.${var.namespace}.svc.cluster.local:${var.cluster_port}", i)],
            var.cluster_peer_add_list,
            var.container_extra_args
          ))
          port {
            container_port = var.container_port
            name           = "http"
          }

          port {
            container_port = var.cluster_port
            name           = "cluster"
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

          volume_mount {
            mount_path = var.dataPath
            name       = "storage-volume"
          }

          volume_mount {
            mount_path = var.configPath
            name       = "alertmanager-config"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = { for map in local.config_maps_list : map.map_name => map if can(map.map_name) }
            content {
              mount_path = volume_mount.value.map_path
              name       = volume_mount.value.map_name
              read_only  = true
            }
          }
          dynamic "volume_mount" {
            for_each = { for map in local.secret_maps_list : map.map_name => map if can(map.map_name) }
            content {
              mount_path = volume_mount.value.map_path
              name       = volume_mount.value.map_name
              read_only  = true
            }
          }
        }


        container {
          name              = var.reloader_sidecar_config.name
          image             = var.reloader_container_image
          image_pull_policy = var.image_pull_policy

          args = [
            "--volume-dir=${var.configPath}",
            "--webhook-method=POST",
            "--webhook-status-code=200",
            "--webhook-retries=3",
            "--webhook-url=http://localhost:${var.container_port}/-/reload",
          ]
          security_context {
            read_only_root_filesystem = true
          }
          resources {
            limits = {
              cpu    = var.reloader_sidecar_config.container_resources.limits_cpu
              memory = var.reloader_sidecar_config.container_resources.limits_memory
            }
            requests = {
              cpu    = var.reloader_sidecar_config.container_resources.requests_cpu
              memory = var.reloader_sidecar_config.container_resources.requests_memory
            }
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            http_get {
              path   = "/metrics"
              scheme = "HTTP"
              port   = var.reloader_sidecar_config.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            http_get {
              path   = "/metrics"
              scheme = "HTTP"
              port   = var.reloader_sidecar_config.container_port
            }
          }

          volume_mount {
            mount_path = var.configPath
            name       = "alertmanager-config"
            read_only  = true
          }

        }

        volume {
          name = "storage-volume"
          empty_dir {
            size_limit = var.container_resources.size_limit
          }
        }

        volume {
          name = "alertmanager-config"
          secret {
            secret_name  = "${var.name}-config"
            default_mode = "0400"
          }
        }

        dynamic "volume" {
          for_each = { for map in local.config_maps_list : map.map_name => map if can(map.map_name) }
          content {
            name = volume.value.map_name
            config_map {
              name         = "${var.name}-${volume.value.map_name}"
              default_mode = "0400"
            }
          }
        }
        dynamic "volume" {
          for_each = { for map in local.secret_maps_list : map.map_name => map if can(map.map_name) }
          content {
            name = volume.value.map_name
            secret {
              secret_name  = "${var.name}-${volume.value.map_name}"
              default_mode = "0400"
            }
          }
        }

      }
    }
  }
}
