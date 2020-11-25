resource "kubernetes_service_account" "sa" {
  count = var.sa_create != "" ? 1 : 0
  depends_on = [kubernetes_secret.sa]
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
    labels      = local.labels
  }
  secret {
    name = var.service_account_name
  }
}

resource "kubernetes_secret" "sa" {
  count = var.sa_create != "" ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
    labels      = local.labels
    annotations = {
      "kubernetes.io/service-account.name": var.service_account_name
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role" "sa" {
  count = var.role_create != "" ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
    labels = local.labels
  }

  rule {
    api_groups     = [""]
    resources      = ["services", "endpoints", "pods"]
    verbs          = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "sa" {
  count = var.sa_create != "" ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.service_account_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.service_account_name
    namespace   = var.namespace
  }
}
