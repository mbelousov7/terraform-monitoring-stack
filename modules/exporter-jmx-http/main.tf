locals {
  labels = merge (
    { name = var.name },
    { module = "exporter-jmx" },
    { system = var.system },
    { instance = var.env.HOST },
    { jmx-role = var.env.JMX_ROLE },
    { jmx-port = var.env.PORT },
    var.labels
  )

  config_maps_list = concat ( var.config_maps_list )
}
