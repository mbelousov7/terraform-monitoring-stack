variable "namespace" {
  description = "kubernetes namespace for prometheus pushgateway"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "pushgateway"
}

variable "labels" {
  description = "additional kubernetes labels, values provided from outside the module"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = number
  default     = 1
}

variable "container_image" {
  description = "pushgateway image"
  type        = string
#  default     = ""
}

variable "strategy" {
  type        = string
  default     = "Recreate"
}

variable "container_port" {
  description = "pushgateway port, must not be changed"
  type        = number
  default     = 9091
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "0.2"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "0.3Gi"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "0.3"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "0.5Gi"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "expose" {
  description = "expose resource type(ingress for kubernetes or route for openshift)"
  type        = string
  default     = "ingress"
}


variable "nginx_ingress_service_name" {
  description = "nginx_ingress_service_name"
  type        = string
  #default     = "nginx-ingress_pushgateway"
}

variable "nginx_ingress_port" {
  description = "nginx ingress port for application(not a application port)"
  type        = number
  default     = 8080
}
