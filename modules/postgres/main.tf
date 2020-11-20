locals {
  labels = merge (
    { name = var.name },
    { module = "postgres" },
    var.labels
  )

}
