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
    service_name          = "${var.name}-sidecar"

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
                //  match_expressions {
                //    key      = "name"
                //    operator = "In"
                //    values   = [var.name]
                //  }
                match_expressions {
                  key      = "module"
                  operator = "In"
                  values   = ["prometheus"]
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
            "exec /bin/prometheus --config.file=${var.configPath}/prometheus-$${HOSTNAME##*-}.yml --storage.tsdb.max-block-duration=${var.blockDuration} --storage.tsdb.min-block-duration=${var.blockDuration} --web.listen-address=:${var.container_port} --storage.tsdb.path=${var.dataPath} --storage.tsdb.retention.time=${var.retentionTime} --storage.tsdb.retention.size=${var.retentionSize} --web.enable-lifecycle --web.enable-admin-api  --log.level=${var.container_args.log_level}",
          ]

          port {
            container_port = var.container_port
            name           = "http"
          }

          security_context {
            read_only_root_filesystem = true
          }

          resources {
            limits = {
              cpu               = var.container_resources.limits_cpu
              memory            = var.container_resources.limits_memory
              ephemeral-storage = var.container_resources.limits_ephemeral_storage
            }
            requests = {
              cpu               = var.container_resources.requests_cpu
              memory            = var.container_resources.requests_memory
              ephemeral-storage = var.container_resources.requests_ephemeral_storage
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
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "serviceaccount"
            read_only  = true
          }

          volume_mount {
            mount_path = var.configPath
            name       = "prometheus-config"
            read_only  = true
          }

          volume_mount {
            mount_path = var.rulesPath
            name       = "prometheus-rules"
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

        dynamic "container" {
          for_each = var.thanos_sidecar_config
          content {
            image             = container.value.container_image
            name              = container.value.name
            image_pull_policy = var.thanos_sidecar_image_pull_policy
            args = concat([
              "sidecar",
              "--tsdb.path=${var.dataPath}",
              "--prometheus.url=http://127.0.0.1:${var.container_port}",
              "--grpc-address=0.0.0.0:${container.value.container_port_grpc}",
              "--http-address=0.0.0.0:${container.value.container_port_http}",
              "--reloader.rule-dir=${var.configPath}",
              "--reloader.rule-dir=${var.rulesPath}",
              ],
              container.value.container_args
            )

            security_context {
              read_only_root_filesystem = true
            }

            port {
              container_port = container.value.container_port_grpc
              name           = "sidecar-grpc"
            }
            port {
              container_port = container.value.container_port_http
              name           = "sidecar-http"
            }

            resources {
              limits = {
                cpu               = container.value.container_resources.limits_cpu
                memory            = container.value.container_resources.limits_memory
                ephemeral-storage = container.value.container_resources.limits_ephemeral_storage
              }
              requests = {
                cpu               = container.value.container_resources.requests_cpu
                memory            = container.value.container_resources.requests_memory
                ephemeral-storage = container.value.container_resources.limits_ephemeral_storage
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

            dynamic "volume_mount" {
              for_each = { for config in var.thanos_sidecar_config : config.name => config if can(config.config_s3) }
              content {
                mount_path = "/thanos/secrets"
                name       = "config-s3"
                read_only  = true
              }
            }

            volume_mount {
              mount_path = var.configPath
              name       = "prometheus-config"
              read_only  = true
            }

            volume_mount {
              mount_path = var.rulesPath
              name       = "prometheus-rules"
              read_only  = true
            }
          }
        }

        volume {
          name = "storage-volume"
          empty_dir {
            size_limit = var.container_resources.size_limit
          }
        }
        /*
        volume {
          name = "serviceaccount"
          projected {
            sources  {
			  service_account_token {
			    path = "token"
			  }
			}
            default_mode = "0400"
          }
        }
*/

        volume {
          name = "serviceaccount"
          secret {
            secret_name  = var.service_account_token_name
            default_mode = "0400"
          }
        }

        dynamic "volume" {
          for_each = { for config in var.thanos_sidecar_config : config.name => config if can(config.config_s3) }
          content {
            name = "config-s3"
            secret {
              secret_name  = "${var.name}-config-s3"
              default_mode = "0400"
            }
          }
        }

        volume {
          name = "prometheus-config"
          config_map {
            name         = "${var.name}-config"
            default_mode = "0400"
          }
        }

        volume {
          name = "prometheus-rules"
          config_map {
            name         = "${var.name}-rules"
            default_mode = "0400"
          }
        }

        dynamic "volume" {
          for_each = toset(var.targets_list)
          content {
            name = "${volume.key}-targets"
            config_map {
              name         = "${var.name}-${volume.key}-targets"
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
      }
    }
  }
}
