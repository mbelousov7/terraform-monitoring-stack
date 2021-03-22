module "kafka-exporter-jmx" {
  for_each         = local.kafka_exporter_jmx_map
  source           = "../../../modules/exporter-jmx"
  namespace        = var.namespace
  label_system     = "kafka-dev"
  config_maps_list = lookup(each.value, "config_maps_list", [])
  container_image  = var.exporter_jmx_container_image
  name             = "exporter-jmx-${each.key}"
  env              = each.value.env
  container_resources = lookup(
    each.value, "container_resources",
    lookup(local.exporter_jmx_roles_container_resources_map, each.value.env.JMX_ROLE)
  )
}

locals {
  kafka_exporter_jmx_map = {
    kafka004-kafka = { env = { SERVICE = "kafka", JMX_ROLE = "kafka", HOST = "kafka004.local", PORT = "7010", } }
    kafka005-kafka = { env = { SERVICE = "kafka", JMX_ROLE = "kafka", HOST = "kafka005.local", PORT = "7010", } }
    kafka006-kafka = { env = { SERVICE = "kafka", JMX_ROLE = "kafka", HOST = "kafka006.local", PORT = "7010", } }
  }
}
