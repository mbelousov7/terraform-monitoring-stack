locals {
  labels = merge(
    { name = var.name },
    { module = "grafana" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      var.env_secret,
      var.ssl_data,
      var.dashboards_map,
      kubernetes_config_map.fluentbit.data,
    )))
    config_lists_sha1 = sha1(jsonencode(concat(
      var.config_maps_list,
      var.secret_maps_list,
    )))
  }

  config_maps_list = concat(var.config_maps_list)
  secret_maps_list = concat(var.secret_maps_list)
  #secret_maps_list = [{}]

}
