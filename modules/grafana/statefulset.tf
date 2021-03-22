resource "kubernetes_stateful_set" "grafana" {

  depends_on = [
    kubernetes_config_map.config-map-list,
    kubernetes_config_map.dashboards,
    kubernetes_service.service,
  ]

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    pod_management_policy = var.pod_management_policy
    replicas              = var.replicas
    service_name          = var.name

    selector {
      match_labels = local.labels
    }
    update_strategy {
      type = var.update_strategy
    }


    template {
      metadata {
        labels      = local.labels
        annotations = local.annotations
      }

      spec {
        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args              = []

          dynamic "env" {
            for_each = var.env
            content {
              name  = env.key
              value = env.value
            }
          }

          env_from {
            secret_ref {
              name = "${var.name}-env"
            }
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

          port {
            container_port = var.container_port
            name           = "http"
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            http_get {
              path   = "/login"
              scheme = "HTTPS"
              port   = var.container_port
            }
            //exec {
            //  command = ["curl", "-k", "${var.env.GF_SERVER_PROTOCOL}://${var.name}:${var.container_port}"]
            //}
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            http_get {
              path   = "/metrics"
              scheme = "HTTPS"
              port   = var.container_port
            }
            //tcp_socket {
            //  port = var.container_port
            //}
          }

          dynamic "volume_mount" {
            for_each = var.dashboards_map
            content {
              mount_path = "/var/lib/grafana/dashboards/${volume_mount.value.folder}/${volume_mount.key}"
              name       = "${volume_mount.value.folder}-${volume_mount.key}"
              read_only  = true
            }
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

          volume_mount {
            mount_path = "/etc/grafana/cert"
            name       = "cert-volume"
            read_only  = true
          }

          volume_mount {
            mount_path = var.env.GF_PATHS_LOGS
            name       = "grafana-logs"
          }

        }

        container {
          name              = var.fluentbit_config.name
          image             = var.fluentbit_container_image
          image_pull_policy = var.image_pull_policy

          args = [
          ]

          resources {
            limits {
              cpu    = var.fluentbit_config.container_resources.limits_cpu
              memory = var.fluentbit_config.container_resources.limits_memory
            }
            requests {
              cpu    = var.fluentbit_config.container_resources.requests_cpu
              memory = var.fluentbit_config.container_resources.requests_memory
            }
          }

          volume_mount {
            mount_path = "/fluent-bit/etc/"
            name       = "fluentbit"
            read_only  = true
          }

          volume_mount {
            mount_path = var.env.GF_PATHS_LOGS
            name       = "grafana-logs"
          }

        }



        dynamic "volume" {
          for_each = var.dashboards_map
          content {
            name = "${volume.value.folder}-${volume.key}"
            config_map {
              name         = "${var.name}-dashboard-${volume.value.folder}-${volume.key}"
              default_mode = "0644"
            }
          }
        }
        dynamic "volume" {
          for_each = { for map in local.config_maps_list : map.map_name => map if can(map.map_name) }
          content {
            name = volume.value.map_name
            config_map {
              name         = "${var.name}-${volume.value.map_name}"
              default_mode = "0644"
            }
          }
        }
        dynamic "volume" {
          for_each = { for map in local.secret_maps_list : map.map_name => map if can(map.map_name) }
          content {
            name = volume.value.map_name
            secret {
              secret_name  = "${var.name}-${volume.value.map_name}"
              default_mode = "0644"
            }
          }
        }

        volume {
          name = "cert-volume"
          secret {
            secret_name  = "${var.name}-ssl"
            default_mode = "0644"
          }
        }

        volume {
          name = "grafana-logs"
          empty_dir {}
        }

        volume {
          name = "fluentbit"
          config_map {
            name         = "${var.name}-fluentbit"
            default_mode = "0644"
          }
        }

      }
    }
  }
}
