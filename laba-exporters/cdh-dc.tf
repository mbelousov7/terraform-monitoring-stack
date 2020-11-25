module "exporter-jmx-cdh-dc" {
  for_each = local.cdh_dc_exporter_jmx_map
  source = "../modules/exporter-jmx-http"
  namespace = var.namespace
  system = each.value.system
  config_maps_list = lookup(each.value, "config_maps_list", [])
  container_image = var.exporter_jmx_container_image
  name = "exporter-jmx-${each.key}-${each.value.env.HOST}-${each.value.env.JMX_ROLE}"
  env = each.value.env
  container_resources_requests_cpu = lookup(
    each.value, "container_resources_requests_cpu",
    lookup(local.exporter_jmx_roles_resources_map[each.value.env.JMX_ROLE], "container_resources_requests_cpu")
  )
  container_resources_limits_cpu = lookup(
    each.value, "container_resources_limits_cpu",
    lookup(local.exporter_jmx_roles_resources_map[each.value.env.JMX_ROLE], "container_resources_limits_cpu")
  )

  container_resources_requests_memory = lookup(
    each.value, "container_resources_requests_memory",
    lookup(local.exporter_jmx_roles_resources_map[each.value.env.JMX_ROLE], "container_resources_requests_memory")
  )

  container_resources_limits_memory = lookup(
    each.value, "container_resources_limits_memory",
    lookup(local.exporter_jmx_roles_resources_map[each.value.env.JMX_ROLE], "container_resources_limits_memory")
  )

}
