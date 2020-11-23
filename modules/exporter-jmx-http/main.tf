locals {
  labels = merge (
    { name = var.name },
    { module = "exporter-jmx" },
    { system = var.system },
    var.labels
  )

  config_maps_list = concat ( var.config_maps_list )
}
