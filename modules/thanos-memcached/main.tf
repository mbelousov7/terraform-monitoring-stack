locals {
  labels = merge(
    { name = var.name },
    { module = "thanos-memcached" },
    var.labels
  )

  annotations = {
  }
}
