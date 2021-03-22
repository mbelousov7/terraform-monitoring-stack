locals {
  labels = merge(
    { name = var.name },
    { module = "pushgateway" },
    var.labels
  )
}
