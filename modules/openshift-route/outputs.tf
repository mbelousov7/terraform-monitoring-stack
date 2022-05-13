output "route_hostname" {
  description = "Route hostname"
  value       = "https://${local.route_prefix}-${var.route_suffix}/"
}
