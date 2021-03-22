terraform {
  required_version = "= 0.14.3"
  required_providers {
    kubernetes = {
      version = "= 1.13.3"
    }
  }
}

provider "kubernetes" {
  load_config_file = false
  insecure         = true
  host             = var.kubernetes_host
  token            = var.kubernetes_token
}
