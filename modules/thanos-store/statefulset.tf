resource "kubernetes_stateful_set" "thanos_store" {
  timeouts {
    create = "10m"
    delete = "2m"
    update = "15m"
  }


  depends_on = [
    kubernetes_secret.config-s3,
    kubernetes_config_map.config,
  ]
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {

    pod_management_policy = "OrderedReady"
    replicas              = var.replicas
    service_name          = "${var.name}-headless"

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

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "module"
                  operator = "In"
                  values   = ["thanos-store"]
                }
              }
            }
          }
        }

        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args = concat([
            "store",
            "--consistency-delay=30m",
            "--grpc-address=0.0.0.0:${var.container_port_grpc}",
            "--http-address=0.0.0.0:${var.container_port}",
            "--objstore.config-file=${var.config_path_s3}/config-s3.yml",
            "--index-cache.config-file=${var.config_path}/config-cache-index.yml",
            "--store.caching-bucket.config-file=${var.config_path}/config-cache-bucket.yml",
            "--chunk-pool-size=${var.cache_bucket_config.chunk_pool_size}",
            "--data-dir=${var.dataDir}",
            ],
            var.container_args
          )

          security_context {
            read_only_root_filesystem = true
          }

          port {
            container_port = var.container_port
            name           = "http"
          }

          port {
            container_port = var.container_port_grpc
            name           = "grpc"
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
            mount_path = var.dataDir
            name       = "data-dir"
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "serviceaccount"
            read_only  = true
          }

          volume_mount {
            mount_path = var.config_path
            name       = "config"
            read_only  = true
          }

          volume_mount {
            mount_path = var.config_path_s3
            name       = "config-s3"
            read_only  = true
          }

        }

        volume {
          name = "data-dir"
          empty_dir {
            size_limit = var.container_resources.size_limit
          }
        }

        volume {
          name = "serviceaccount"
          secret {
            secret_name  = var.service_account_token_name
            default_mode = "0400"
          }
        }

        volume {
          name = "config"
          config_map {
            name         = "${var.name}-config"
            default_mode = "0400"
          }
        }

        volume {
          name = "config-s3"
          secret {
            secret_name  = "${var.name}-config-s3"
            default_mode = "0400"
          }
        }

      }

    }
  }
}
