resource "kubernetes_config_map" "config-main" {
  for_each = {for configMap in local.configMap_volumes:  configMap.name => configMap}
  metadata {
    name = each.value.config_map_name
    namespace = var.namespace
    labels = local.labels
  }

  data = each.value.config_map_data

}

#resource "kubernetes_config_map" "config-rules" {
#  metadata {
#    name = "${var.app_name}-config-rules"
#    namespace = var.namespace
#    labels = local.labels
#  }

#  data = {
#    "rules.yaml" = file("./${var.app_name}/rules.yaml")
#  }

#}
