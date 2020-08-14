module "nginx-ingress" {
  source = "../modules/nginx-ingress"
  namespace = var.namespace
  depends_on = [ kubernetes_namespace.monitoring ]
  app_name = "nginx-ingress"
  container_image = "nginx"
  container_name = "nginx-ingress"
  server_list = local.prometheus_list
}
