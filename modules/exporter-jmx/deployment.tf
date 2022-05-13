resource "kubernetes_deployment" "exporter" {
  timeouts {
    create = "5m"
    delete = "3m"
    update = "5m"
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
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args              = []

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = var.container_port
            name           = "http"
          }

          dynamic "env" {
            for_each = var.env
            content {
              name  = env.key
              value = env.value
            }
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
          /*
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
              path = "/-/healthy"
              scheme = "HTTP"
              port = var.container_port
            }
          }
*/
          dynamic "volume_mount" {
            for_each = { for map in local.config_maps_list : map.map_name => map if can(map.map_name) }
            content {
              mount_path = volume_mount.value.map_path
              name       = volume_mount.value.map_name
              read_only  = true
            }
          }

          volume_mount {
            mount_path = var.cachePath
            name       = "cache-volume"
          }
        }

        volume {
          name = "cache-volume"
          empty_dir {}
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
      }
    }
  }
}
