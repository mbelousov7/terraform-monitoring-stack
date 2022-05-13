output "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  value       = var.name
}

output "service_name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  value       = kubernetes_service.service.metadata[0].name
}

output "container_port" {
  description = "app port"
  value       = var.container_port
}

output "replicas" {
  description = "replicas number"
  value       = var.replicas
}
