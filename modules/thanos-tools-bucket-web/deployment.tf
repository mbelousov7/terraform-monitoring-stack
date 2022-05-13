resource "kubernetes_deployment" "thanos_tools_bucket_web" {
  timeouts {
    create = "4m"
    delete = "4m"
    update = "4m"
  }
  depends_on = [
    kubernetes_secret.config-s3,
  ]
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
          args = concat([
            "tools",
            "bucket",
            "web",
            "--http-address=0.0.0.0:${var.container_port}",
            "--objstore.config-file=${var.config_path_s3}/config-s3.yml",
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
            mount_path = var.config_path_s3
            name       = "config-s3"
            read_only  = true
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