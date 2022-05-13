locals {
  labels = merge(
    { name = var.name },
    { module = "thanos-query-frontend" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_secret.secret-env.data,
      kubernetes_config_map.config.data,
    )))
  }

}
