resource "kubernetes_deployment" "grafana" {
  timeouts {
    create = "2m"
    delete = "1m"
    update = "2m"
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
          args = []
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
              cpu    = var.container_resources_limits_cpu
              memory = var.container_resources_limits_memory
            }
            requests {
              cpu    = var.container_resources_requests_cpu
              memory = var.container_resources_requests_memory
            }
          }

          liveness_probe {
            timeout_seconds = 60
            period_seconds = 60
            failure_threshold = 1
            exec {
              command = ["curl", "${var.name}.${var.namespace}.svc.cluster.local:3000"]
            }
          }

          dynamic "volume_mount" {
            for_each = local.config_maps_list
            content {
              mount_path  = volume_mount.value.mount_path
              name = volume_mount.value.name
            }
          }
          dynamic "volume_mount" {
            for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
            content {
              mount_path  = volume_mount.value.mount_path
              name = volume_mount.value.name
            }
          }
        }

        dynamic "volume" {
          for_each = local.config_maps_list
          content {
            name = volume.value.name
            config_map {
              name = "${var.name}-${volume.value.config_map_name}"
              default_mode = "0644"
            }
          }
        }
        dynamic "volume" {
          for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
          content {
            name = volume.value.name
            secret {
              secret_name = "${var.name}-${volume.value.secret_name}"
              default_mode = "0644"
            }
          }
        }
      }
  }
 }
}