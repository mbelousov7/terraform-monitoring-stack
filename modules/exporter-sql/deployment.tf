resource "kubernetes_deployment" "exporter-sql-select" {
  timeouts {
    create = "2m"
    delete = "1m"
    update = "3m"
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
          args = [
          ]

          dynamic "env" {
            for_each = var.env
            content {
              name  = env.key
              value = env.value
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

		  
		  volume_mount {
		    mount_path  = "/exporter-sql/config/"
			name = "config"
		  }

		  volume_mount {
		    mount_path  = "/exporter-sql/rules/"
			name = "rules"
		  }

        }
		
		volume {
            name = "rules"
            config_map {
              name = "${var.name}-rules"
              default_mode = "0644"
            }			
		}
		
		volume {
            name = "config"
            secret {
              secret_name = "${var.name}-config"
              default_mode = "0644"
            }			
		}
		
      }
  }
 }
}
