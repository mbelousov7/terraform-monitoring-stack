output "route_hostname_default" {
  description = "Route hostname"
  value       = module.test-0-default.route_hostname
}

output "route_hostname_prefix" {
  description = "Route hostname"
  value       = module.test-10-with-prefix.route_hostname
}
