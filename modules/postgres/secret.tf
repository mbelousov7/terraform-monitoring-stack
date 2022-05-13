resource "kubernetes_secret" "env" {
  metadata {
    name      = "${var.name}-env"
    namespace = var.namespace
    labels    = local.labels
  }

  data = var.env_secret

  #type = "kubernetes.io/basic-auth"
}
