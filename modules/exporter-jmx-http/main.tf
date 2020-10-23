locals {
  app_name = "${var.system}-exporter-jmx"
  labels = merge (
    { app = local.app_name },
    var.labels
  )
}
