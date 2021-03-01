resource "kubernetes_deployment" "thanos_store" {
  timeouts {
    create = "4m"
    delete = "4m"
    update = "4m"
  }
  depends_on = [
    kubernetes_secret.config-s3,
    kubernetes_config_map.config,
  ]
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
        annotations = local.annotations
      }

      spec {

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key = "name"
                  operator = "In"
                  values = [ var.name ]
                }
              }
            }
          }
        }

        container {
          image = var.container_image
          image_pull_policy = var.image_pull_policy
          name  = var.name
          args = concat([
            "store",
            "--grpc-address=0.0.0.0:${var.container_port_grpc}",
            "--http-address=0.0.0.0:${var.container_port}",
            "--objstore.config-file=${var.config_path_s3}/config-s3.yml",
            "--index-cache.config-file=${var.config_path}/cache.yml",
            "--chunk-pool-size=${var.container_resources.thanos_chunk_pool_size}",
            "--data-dir=${var.dataDir}"
          ],
          var.container_args
         )

          port {
            container_port = var.container_port
            name = "http"
          }

          port {
            container_port = var.container_port_grpc
            name = "grpc"
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
            timeout_seconds = var.liveness_probe.timeout_seconds
            period_seconds = var.liveness_probe.period_seconds
            failure_threshold = var.liveness_probe.failure_threshold
            http_get {
              path = "/-/healthy"
              scheme = "HTTP"
              port = var.container_port
            }
          }

          readiness_probe {
            initial_delay_seconds = var.readiness_probe.initial_delay_seconds
            timeout_seconds = var.readiness_probe.timeout_seconds
            period_seconds = var.readiness_probe.period_seconds
            failure_threshold = var.readiness_probe.failure_threshold
            http_get {
              path = "/-/ready"
              scheme = "HTTP"
              port = var.container_port
            }
          }

          volume_mount {
              mount_path = var.dataDir
              name       = "data-dir"
          }

          volume_mount {
              mount_path = var.config_path
              name       = "config"
              read_only = true
          }

          volume_mount {
              mount_path = var.config_path_s3
              name       = "config-s3"
              read_only = true
          }

        }

        volume {
          name = "data-dir"
          empty_dir {}
        }

        volume {
          name = "config"
            config_map {
              name = "${var.name}-config"
              default_mode = "0644"
            }
        }

        volume {
          name = "config-s3"
          secret {
            secret_name = "${var.name}-config-s3"
            default_mode = "0644"
          }
        }

      }

    }
  }
}
