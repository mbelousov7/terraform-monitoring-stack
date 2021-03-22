resource "kubernetes_config_map" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  data = var.config_data
}

resource "kubernetes_config_map" "rules" {
  metadata {
    name      = "${var.name}-rules"
    namespace = var.namespace
    labels    = local.labels
  }
  data = var.rules_data
}

resource "kubernetes_config_map" "config-map-list" {
  for_each = { for configMap in local.config_maps_list : configMap.map_name => configMap }
  metadata {
    name      = "${var.name}-${each.value.map_name}"
    namespace = var.namespace
    labels    = local.labels
  }
  data = each.value.map_data
}

resource "kubernetes_config_map" "targets" {
  for_each = toset(var.targets_list)
  metadata {
    name      = "${var.name}-${each.key}-targets"
    namespace = var.namespace
    labels    = local.labels
  }
  data = {
    "${each.key}-targets.json" = file("${var.targets_folder}/${each.key}.json")
  }
}

/*
locals {
  targets_data = {
      "test.json" = "{}"
  }

  list = [
      "cdh-dc",
      "cdh-infra",
      "cdh-od",
      "sdp-cl",
  ]
  targets_data1 = zipmap (local.list,local.list)
  targets_data2 = zipmap (
    formatlist("%s-targets.json", local.list),
    formatlist("${var.targets_folder}/%s.json", local.list)
  )
  targets_data2 =
}

resource "kubernetes_config_map" "targets-test" {
  metadata {
    name = "${var.name}-test"
    namespace = var.namespace
    labels = local.labels
  }
  data = local.targets_data2
}






*/
