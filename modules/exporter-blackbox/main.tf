locals {
  labels = merge(
    { name = var.name },
    { module = "exporter-blackbox" },
    { sd = "service" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_config_map.config.data,
    )))
  }
}
