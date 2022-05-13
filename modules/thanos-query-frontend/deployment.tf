resource "kubernetes_deployment" "thanos_query_frontend" {
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
          /*
          dynamic "pod_affinity" {
            for_each = tostring(var.replicas) != "1" ? [1] : []
            content {
              required_during_scheduling_ignored_during_execution {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_expressions {
                    key = "name"
                    operator = "In"
                    values = [ var.name_thanos_query ]
                  }
                }
              }
            }
          }
*/
        }

        automount_service_account_token = false
        container {
          image             = var.container_image
          image_pull_policy = var.image_pull_policy
          name              = var.name
          args = concat([
            "query-frontend",
            "--http-address=0.0.0.0:${var.container_port}",
            "--query-frontend.downstream-url=http://${var.name_thanos_query}:${var.container_port}",
            "--query-frontend.downstream-tripper-config-file=${var.config_path}/config-downstream-tripper.yml",
            "--query-range.response-cache-config-file=${var.config_path}/config-cache-query-range.yml",
            "--labels.response-cache-config-file=${var.config_path}/config-cache-labels.yml",
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
            mount_path = var.config_path
            name       = "config"
            read_only  = true
          }

        }


        volume {
          name = "config"
          config_map {
            name         = "${var.name}-config"
            default_mode = "0400"
          }
        }

      }
    }
  }
}
