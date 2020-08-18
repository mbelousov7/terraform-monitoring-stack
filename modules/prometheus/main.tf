locals {
  labels = merge (
    { app = var.app_name },
    var.labels
  )

  config_maps_list = var.config_maps_list

}
