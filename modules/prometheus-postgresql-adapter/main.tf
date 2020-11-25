locals {
  labels = merge (
    { name = var.name },
    { module = "prometheus-postgresql-adapter" },
    var.labels
  )

}
