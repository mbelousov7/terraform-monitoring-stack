resource "kubernetes_stateful_set" "thanos_compact" {
  depends_on = [
    kubernetes_secret.config-s3,
  ]
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    //!!!!!replicas count must be 1 for thanos-compact
    pod_management_policy = "OrderedReady"
    replicas              = 1
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
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args = concat([
            "compact",
            "--wait",
            //"--compact.enable-vertical-compaction",
            "--deduplication.replica-label=${var.prometheus_replica_label}",
            "--http-address=0.0.0.0:${var.container_port}",
            "--objstore.config-file=${var.config_path_s3}/config-s3.yml",
            "--data-dir=${var.dataDir}",
            "--retention.resolution-raw=${var.retention.resolution_raw}",
            "--retention.resolution-5m=${var.retention.resolution_5m}",
            "--retention.resolution-1h=${var.retention.resolution_1h}",
            ],
            var.container_args
          )
          port {
            container_port = var.container_port
            name           = "http"
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
            mount_path = var.config_path_s3
            name       = "config-s3"
            read_only  = true
          }

        }

        volume {
          name = "data-dir"
          empty_dir {}
        }

        volume {
          name = "config-s3"
          secret {
            secret_name  = "${var.name}-config-s3"
            default_mode = "0644"
          }
        }

      }

    }
  }
}
