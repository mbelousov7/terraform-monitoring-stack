resource "kubernetes_config_map" "config" {
  for_each = {for configMap in local.config_maps_list:  configMap.name => configMap}
  metadata {
    name = "${var.name}-${each.value.config_map_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.config_map_data
}
