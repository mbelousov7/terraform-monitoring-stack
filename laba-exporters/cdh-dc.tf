module "exporter-jmx-cdh-dc" {
  for_each = local.cdh_dc_exporter_jmx_map
  source = "../modules/exporter-jmx-http"
  namespace = var.namespace
  system = each.value.system
  container_image = "drjetf/exporter-jmx:v1.2.0"
  container_name = each.key
  env_jmx_role = each.value.env_jmx_role
  env_host = each.value.env_host
  env_port = each.value.env_port
  env_jvm_opts = lookup(each.value, "env_jmx_role", "")
  env_jmxurl = lookup(each.value, "env_jmx_role", "")
  env_ssl = lookup(each.value, "env_jmx_role", "ssl: false")
  env_username = lookup(each.value, "env_jmx_role", "")
  env_password = lookup(each.value, "env_jmx_role", "")
  container_resources_requests_cpu = lookup(each.value, "container_resources_requests_cpu", "100m")
  container_resources_limits_cpu = lookup(each.value, "container_resources_limits_cpu", "200m")
  container_resources_requests_memory = lookup(each.value, "container_resources_requests_memory", "128Mi")
  container_resources_limits_memory = lookup(each.value, "container_resources_limits_memory", "264Mi")
}
