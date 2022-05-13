resource "kubernetes_deployment" "nginx-ingress" {
  timeouts {
    create = "5m"
    delete = "2m"
    update = "7m"
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

        automount_service_account_token = false

        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = var.container_port
            protocol       = "TCP"
            name           = "nginx"
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

          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "config-volume"
            read_only  = true
          }

          volume_mount {
            mount_path = "/etc/nginx/password"
            name       = "password-volume"
            read_only  = true
          }
          volume_mount {
            mount_path = "/var/log/nginx"
            name       = "log-volume"
          }
          volume_mount {
            mount_path = "/var/lib/nginx/tmp"
            name       = "temp-volume"
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "temp-volume"
          }

          dynamic "volume_mount" {
            for_each = { for server, config in var.server_map : server => config if can(config.ssl_data) }
            content {
              mount_path = "/etc/nginx/ssl/${volume_mount.key}"
              name       = "ssl-${volume_mount.key}"
              read_only  = true
            }
          }

          dynamic "volume_mount" {
            for_each = { for config in var.kerberos_config : config.config_name => config if can(config.config_name) }
            content {
              mount_path = volume_mount.value.map_path
              sub_path   = volume_mount.value.config_subPath
              name       = volume_mount.value.config_name
              read_only  = true
            }
          }
          dynamic "volume_mount" {
            for_each = { for config in var.kerberos_keytab : config.config_name => config if can(config.config_name) }
            content {
              mount_path = volume_mount.value.map_path
              name       = volume_mount.value.config_name
              read_only  = true
            }
          }

        }

        volume {
          name = "config-volume"
          config_map {
            name         = "${var.name}-config"
            default_mode = "0400"
          }
        }

        volume {
          name = "log-volume"
          empty_dir {}
        }

        volume {
          name = "temp-volume"
          empty_dir {}
        }

        volume {
          name = "password-volume"
          secret {
            secret_name  = "${var.name}-password-secret"
            default_mode = "0400"
          }
        }

        dynamic "volume" {
          for_each = { for server, config in var.server_map : server => config if can(config.ssl_data) }
          content {
            name = "ssl-${volume.key}"
            secret {
              secret_name  = "${var.name}-ssl-${volume.key}"
              default_mode = "0400"
            }
          }
        }
        dynamic "volume" {
          for_each = { for config in var.kerberos_config : config.config_name => config if can(config.config_name) }
          content {
            name = volume.value.config_name
            config_map {
              name         = "${var.name}-${volume.value.config_name}"
              default_mode = "0400"
            }
          }
        }
        dynamic "volume" {
          for_each = { for config in var.kerberos_keytab : config.config_name => config if can(config.config_name) }
          content {
            name = volume.value.config_name
            secret {
              secret_name  = "${var.name}-${volume.value.config_name}-secret"
              default_mode = "0400"
            }
          }
        }

      }
    }
  }
}