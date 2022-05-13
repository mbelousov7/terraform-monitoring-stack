resource "kubernetes_stateful_set" "grafana" {
  timeouts {
    create = "8m"
    delete = "1m"
    update = "8m"
  }

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

        automount_service_account_token  = false

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
            limits = {
              cpu    = var.container_resources.limits_cpu
              memory = var.container_resources.limits_memory
            }
            requests = {
              cpu    = var.container_resources.requests_cpu
              memory = var.container_resources.requests_memory
            }
          }

          port {
            container_port = var.container_port
            name           = "https"
          }

          security_context {
            read_only_root_filesystem = true
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

          volume_mount {
            mount_path = "/var/lib/grafana"
            name       = "grafana-tmp"
          }

        }

        container {
          name              = var.fluentbit_config.name
          image             = var.fluentbit_container_image
          image_pull_policy = var.image_pull_policy

          args = [
          ]
          security_context {
            read_only_root_filesystem = true
          }
          resources {
            limits = {
              cpu    = var.fluentbit_config.container_resources.limits_cpu
              memory = var.fluentbit_config.container_resources.limits_memory
            }
            requests = {
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


        dynamic "container" {
          for_each = var.thanos_query_frontend
          content {
            image             = container.value.container_image
            image_pull_policy = container.value.image_pull_policy
            name              = container.value.name
            args = concat([
              "query-frontend",
              "--http-address=0.0.0.0:${container.value.container_port}",
              "--query-frontend.downstream-url=http://${container.value.name_thanos_query}:${container.value.container_port}",
              "--query-frontend.downstream-tripper-config-file=${container.value.config_path}/config-downstream-tripper.yml",
              "--query-range.response-cache-config-file=${container.value.config_path}/config-cache-query-range.yml",
              "--labels.response-cache-config-file=${container.value.config_path}/config-cache-labels.yml",
              ],
              container.value.container_args
            )

            port {
              container_port = container.value.container_port
              name           = "http"
            }
            security_context {
              read_only_root_filesystem = true
            }
            resources {
              limits = {
                cpu    = container.value.container_resources.limits_cpu
                memory = container.value.container_resources.limits_memory
              }
              requests = {
                cpu    = container.value.container_resources.requests_cpu
                memory = container.value.container_resources.requests_memory
              }
            }

            liveness_probe {
              initial_delay_seconds = container.value.liveness_probe.initial_delay_seconds
              timeout_seconds       = container.value.liveness_probe.timeout_seconds
              period_seconds        = container.value.liveness_probe.period_seconds
              failure_threshold     = container.value.liveness_probe.failure_threshold
              http_get {
                path   = "/-/healthy"
                scheme = "HTTP"
                port   = container.value.container_port
              }
            }

            readiness_probe {
              initial_delay_seconds = container.value.readiness_probe.initial_delay_seconds
              timeout_seconds       = container.value.readiness_probe.timeout_seconds
              period_seconds        = container.value.readiness_probe.period_seconds
              failure_threshold     = container.value.readiness_probe.failure_threshold
              http_get {
                path   = "/-/ready"
                scheme = "HTTP"
                port   = container.value.container_port
              }
            }

            volume_mount {
              mount_path = container.value.config_path
              name       = "thanos-query-frontend-config"
              read_only  = true
            }
          }
        }

        dynamic "volume" {
          for_each = var.thanos_query_frontend
          content {
            name = "thanos-query-frontend-config"
            config_map {
              name         = "${volume.value.name}-config"
              default_mode = "0400"
            }
          }
        }

        dynamic "volume" {
          for_each = var.dashboards_map
          content {
            name = "${volume.value.folder}-${volume.key}"
            config_map {
              name         = "${var.name}-${volume.value.folder}-${volume.key}"
              default_mode = "0400"
            }
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

        volume {
          name = "cert-volume"
          secret {
            secret_name  = "${var.name}-ssl"
            default_mode = "0400"
          }
        }

        volume {
          name = "grafana-logs"
          empty_dir {}
        }
        volume {
          name = "grafana-tmp"
          empty_dir {}
        }

        volume {
          name = "fluentbit"
          config_map {
            name         = "${var.name}-fluentbit"
            default_mode = "0400"
          }
        }

      }
    }
  }
}
