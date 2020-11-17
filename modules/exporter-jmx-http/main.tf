locals {
  labels = merge (
    { name = var.name },
    { module = "exporter-jmx" },
    var.labels
  )

  config_maps_list = concat ( var.config_maps_list )
}
