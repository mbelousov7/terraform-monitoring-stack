terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {
  version = ">= 1.10.0"
  load_config_file       = false
  insecure               = true
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
}


resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.kubernetes_namespace
  }
}

module "prometheus" {
  source = "./modules/prometheus"
  #kubernetes_namespace = "${kubernetes_namespace.monitoring.id}"
  kubernetes_namespace = var.kubernetes_namespace
  container_image = "prom/prometheus:latest"
  container_name = "prometheus"
}
