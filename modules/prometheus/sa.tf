resource "kubernetes_service_account" "sa" {
  count = var.sa_create == true ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
  }
  secret {
    name = "${var.service_account_name}-sa-token"
  }
}

resource "kubernetes_secret" "sa" {
  count = var.sa_create == true ? 1 : 0
  depends_on = [kubernetes_service_account.sa]
  metadata {
    name = "${var.service_account_name}-sa-token"
    namespace   = var.namespace
    annotations = {
      "kubernetes.io/service-account.name": var.service_account_name
    }
    #labels = local.labels
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role" "sa" {
  count = var.role_create == true ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace   = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["services", "endpoints", "pods"]
    verbs          = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "sa" {
  count = var.sa_create == true ? 1 : 0
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
