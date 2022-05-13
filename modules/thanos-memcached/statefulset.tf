locals {
  timeout = var.replicas * 2
}

resource "kubernetes_stateful_set" "thanos_memcached" {

  timeouts {
    create = "${local.timeout}m"
    delete = "${local.timeout}m"
    update = "${local.timeout}m"
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {

    pod_management_policy = "OrderedReady"
    replicas              = var.replicas
    service_name          = var.name

    update_strategy {
      type = "RollingUpdate"
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
        service_account_name            = var.service_account_name
        automount_service_account_token = var.automount_service_account_token

        /*
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
*/
        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args = concat([
            "memcached",
            "-p ${var.container_port}",
            "-m ${var.container_resources.requests_memory}",
            ],
            var.container_args
          )

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = var.container_port
            name           = "memcached"
          }
          port {
            container_port = var.container_port_metrics
            name           = "http"
          }

          resources {
            limits = {
              cpu    = var.container_resources.limits_cpu
              memory = var.container_resources.limits_memory
              //ephemeral-storage = var.container_resources.limits_ephemeral_storage
            }
            requests = {
              cpu    = var.container_resources.requests_cpu
              memory = var.container_resources.requests_memory
              //ephemeral-storage = var.container_resources.requests_ephemeral_storage
            }
          }

          liveness_probe {
            initial_delay_seconds = var.liveness_probe.initial_delay_seconds
            timeout_seconds       = var.liveness_probe.timeout_seconds
            period_seconds        = var.liveness_probe.period_seconds
            failure_threshold     = var.liveness_probe.failure_threshold
            tcp_socket {
              port = var.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds       = var.readiness_probe.timeout_seconds
            period_seconds        = var.readiness_probe.period_seconds
            failure_threshold     = var.readiness_probe.failure_threshold
            tcp_socket {
              port = var.container_port
            }
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "serviceaccount"
            read_only  = true
          }


        }

        volume {
          name = "serviceaccount"
          secret {
            secret_name  = var.service_account_token_name
            default_mode = "0400"
          }
        }

      }

    }
  }
}
