locals {
  web_route = var.expose == "route" ? {
    "${var.name}" = {
      suffix = var.route_suffix
    }
  } : {}
  geo_route = var.geo_route == true ? {
    "${var.name}-geo" = {
      suffix = var.geo_route_suffix
      prefix = "grafana"
    }
  } : {}
}

module "openshift_routes" {
  source             = "../openshift-route"
  for_each           = merge(local.web_route, local.geo_route)
  route_namespace    = var.namespace
  route_prefix       = lookup(each.value, "prefix", null)
  route_name         = each.key
  route_suffix       = each.value.suffix
  route_service_port = var.container_port
  route_service_name = var.name
}
