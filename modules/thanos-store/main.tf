locals {
  labels = merge(
    { name = var.name },
    { module = "thanos-store" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_secret.config-s3.data,
      kubernetes_config_map.config.data,
    )))
  }

}
