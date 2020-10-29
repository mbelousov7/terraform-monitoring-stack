locals {
  app_name = "${var.system}-${var.container_name}"
  labels = merge (
    { app = local.app_name },
    var.labels
  )
}
