resource "kubernetes_secret" "grafana-secret-config" {
  for_each = {for secret in local.secret_maps_list:  secret.name => secret if can(secret.secret_name)}
  metadata {
    name = "${var.name}-${each.value.secret_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.secret_data
}

resource "kubernetes_secret" "grafana-secret-env" {
  metadata {
    name = "${var.name}-env"
    namespace = var.namespace
    labels = local.labels
  }

  data = var.env_secret

  #type = "kubernetes.io/basic-auth"
}
