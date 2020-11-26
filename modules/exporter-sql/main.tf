locals {
  labels = merge (
    { name = var.name },
    { module = "exporter-sql-select" },
    { system = var.system },
    var.labels
  )

}
