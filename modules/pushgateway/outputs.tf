output "service_name" {
  description = "app service name"
  value       = kubernetes_service.service.metadata[0].name
}
