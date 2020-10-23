resource "kubernetes_ingress" "nginx-ingress" {
  count = var.expose == "ingress" ? 1 : 0
  metadata {
    name = var.app_name
    namespace = var.namespace
    labels = local.labels
  }
  spec {
    rule {
      host = "${var.app_name}.local"
      http {
        path {
          backend {
            service_name = var.nginx_ingress_service_name
            service_port = var.nginx_ingress_port
          }
        }
      }
    }
  }
}
