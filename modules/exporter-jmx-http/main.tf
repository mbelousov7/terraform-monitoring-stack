locals {
  labels = merge (
    { name = var.name },
    { module = "exporter-jmx" },
    { system = var.system },
    { instance = var.env.HOST },
    { jmxrole = var.env.JMX_ROLE },
    { jmxport = var.env.PORT },
    var.labels
  )

  config_maps_list = concat ( var.config_maps_list )
}
