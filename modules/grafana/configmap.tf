resource "kubernetes_config_map" "config" {
  for_each = {for configMap in local.config_maps_list:  configMap.map_name => configMap}
  metadata {
    name = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.map_data
}
