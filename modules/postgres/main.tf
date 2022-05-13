locals {
  labels = merge(
    { name = var.name },
    { module = "postgres" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_secret.env.data
    )))
  }

}
