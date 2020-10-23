resource "kubernetes_deployment" "exporter" {
  timeouts {
    create = "5m"
    delete = "2m"
    update = "5m"
  }

  metadata {
    name        = var.app_name
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
          name  = var.app_name
          args = [
          ]
          env {
            name = "EXPORTER_PORT"
            value = var.env_exporter_port
          }
          env {
            name = "HOST"
            value = var.env_host
          }
          env {
            name = "PORT"
            value = var.env_port
          }
          env {
            name = "JVM_OPTS"
            value = var.env_jvm_opts
          }
          env {
            name = "JMXURL"
            value = var.env_jmxurl
          }
          env {
            name = "USERNAME"
            value = var.env_username
          }
          env {
            name = "PASSWORD"
            value = var.env_password
          }
          env {
            name = "SSL"
            value = var.env_ssl
          }
          env {
            name = "JMX_ROLE"
            value = var.env_jmx_role
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

        }
      }
  }
 }
}
