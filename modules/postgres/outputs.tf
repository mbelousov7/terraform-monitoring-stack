output "app_name" {
  description = "app stateful_set name"
  value       = kubernetes_stateful_set.postgres.metadata[0].name
}

output "container_port" {
  description = "app port"
  value       = var.container_port
}
