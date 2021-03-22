locals {
  labels = merge(
    { name = var.name },
    { module = "prometheus" },
    var.labels
  )

  config_maps_list = concat(var.config_maps_list)
  secret_maps_list = concat(var.secret_maps_list)
  #secret_maps_list = [{}]

}
