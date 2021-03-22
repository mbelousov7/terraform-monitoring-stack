resource "kubernetes_stateful_set" "prometheus" {
  depends_on = [
    kubernetes_config_map.targets,
    kubernetes_config_map.config,
    kubernetes_config_map.config-map-list,
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
        labels = local.labels
      }

      spec {
        service_account_name            = var.service_account_name
        automount_service_account_token = var.automount_service_account_token

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

        container {
          name              = var.name
          image             = var.container_image
          image_pull_policy = var.image_pull_policy

          command = ["/bin/sh"]
          args = [
            "-c",
            "exec /bin/prometheus --config.file=${var.configPath}/prometheus-$${HOSTNAME##*-}.yml --web.listen-address=:${var.container_port} --storage.tsdb.path=${var.dataPath} --storage.tsdb.retention.time=${var.retentionTime} --storage.tsdb.retention.size=${var.retentionSize} --web.enable-lifecycle --web.enable-admin-api",
          ]

          port {
            container_port = var.container_port
            name           = "prometheus"
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
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            #exec {
            #  command = ["curl", "-X", "POST", "127.0.0.1:${var.container_port}/-/reload"]
            #}
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
            name       = "prometheus-config"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = toset(var.targets_list)
            content {
              mount_path = "/etc/prometheus/file_sd_config_list/${volume_mount.key}"
              name       = "${volume_mount.key}-targets"
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
            name       = "prometheus-config"
            read_only  = true
          }

        }




        container {
          #          content {
          image = var.pg_adapter_config.container_image
          name  = var.pg_adapter_config.name
          args  = []

          port {
            container_port = var.pg_adapter_config.container_port
            name           = "pg-adapter"
          }

          dynamic "env" {
            for_each = var.pg_adapter_config.env
            content {
              name  = env.key
              value = env.value
            }
          }

          env_from {
            secret_ref {
              name = "${var.name}-${var.pg_adapter_config.name}-env"
            }
          }

          resources {
            limits {
              cpu    = var.pg_adapter_config.container_resources.limits_cpu
              memory = var.pg_adapter_config.container_resources.limits_memory
            }
            requests {
              cpu    = var.pg_adapter_config.container_resources.requests_cpu
              memory = var.pg_adapter_config.container_resources.requests_memory
            }
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            #exec {
            #  command = ["curl", "-X", "POST", "${var.name}:${var.container_port}/-/reload"]
            #}
            tcp_socket {
              port = var.pg_adapter_config.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            tcp_socket {
              port = var.pg_adapter_config.container_port
            }
          }

        }
        #        }

        volume {
          name = "storage-volume"
          empty_dir {}
        }

        volume {
          name = "prometheus-config"
          config_map {
            name         = "${var.name}-config"
            default_mode = "0644"
          }
        }

        dynamic "volume" {
          for_each = toset(var.targets_list)
          content {
            name = "${volume.key}-targets"
            config_map {
              name         = "${var.name}-${volume.key}-targets"
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

      } //spec


    }
  }
}
