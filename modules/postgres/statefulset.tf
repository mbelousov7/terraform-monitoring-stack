resource "kubernetes_stateful_set" "postgres" {

  timeouts {
    create = "4m"
    delete = "2m"
    update = "4m"
  }


  depends_on = [
    kubernetes_service.service,
  ]
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas              = 1
    pod_management_policy = var.pod_management_policy

    update_strategy {
      type = var.update_strategy
    }
    service_name = var.name

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
          args = concat([
            ],
            var.container_args
          )

          security_context {
            read_only_root_filesystem = var.read_only_root_filesystem
          }

          port {
            container_port = var.container_port
            name           = "postgres"
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

          liveness_probe {
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            tcp_socket {
              port = var.container_port
            }
          }

          readiness_probe {
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            tcp_socket {
              port = var.container_port
            }
          }

          volume_mount {
            mount_path = "/var/lib/pgsql/"
            name       = "data"
          }

          volume_mount {
            mount_path = "/pgsql/"
            name       = "pgsql"
          }


          volume_mount {
            mount_path = "/tmp/"
            name       = "tmp"
          }

          volume_mount {
            mount_path = "/var/run/postgresql/"
            name       = "run"
          }

        }

        volume {
          name = "data"
          empty_dir {
            size_limit = "256Mi"
          }
        }

        volume {
          name = "pgsql"
          empty_dir {
            size_limit = "256Mi"
          }
        }

        volume {
          name = "tmp"
          empty_dir {
            size_limit = "50Mi"
          }
        }

        volume {
          name = "run"
          empty_dir {
            size_limit = "50Mi"
          }
        }


      }
    }
  }
}
