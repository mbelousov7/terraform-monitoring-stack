output "service_name" {
  description = "app service name"
  value       = kubernetes_service.service.metadata[0].name
}

output "service_port" {
  description = "app service name"
  value       = var.container_port

}
