resource "kubernetes_config_map" "dashboards" {
  for_each =  var.dashboards_map
  metadata {
    name = "${var.name}-dashboard-${each.value.folder}-${each.key}"
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    "${each.key}.json" = file("${var.dashboards_folder}/${each.value.folder}/${each.key}.json")
  }
}


resource "kubernetes_config_map" "config-map-list" {
  for_each = {for configMap in local.config_maps_list:  configMap.map_name => configMap}
  metadata {
    name = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_config_map" "fluentbit" {
  metadata {
    name = "${var.name}-fluentbit"
    namespace = var.namespace
    labels = local.labels
  }
  data = {
    "fluent-bit.conf" = templatefile("${path.module}/fluentbit/fluent-bit.conf", {
        fluentbit_config_output = var.fluentbit_config_output
      })
    "parsers.conf" = file("${path.module}/fluentbit/parsers.conf")
  }
}
