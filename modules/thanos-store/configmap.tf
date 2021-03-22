locals {
  config_cache = {
    "cache.yml" = <<EOF
type: IN-MEMORY
config:
  max_size: "${var.container_resources.thanos_cache_max_size}"
  validity: 6h
EOF
  }
}


resource "kubernetes_config_map" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  data = local.config_cache
}
