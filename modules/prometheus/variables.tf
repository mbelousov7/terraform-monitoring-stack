variable "kubernetes_namespace" {
  description = "kubernetes namespace"
  type        = string
}

variable "prometheus_name" {
  description = "prometheus_name"
  type        = string
  default     = "prometheus"
}

variable "labels" {
  description = "labels"
  type        = map(string)
  default     = {
    app = "prometheus"
  }
}

variable "replicas" {
  type        = string
  default     = 1
}

variable "container_image" {
  type        = string
}

variable "container_name" {
  type        = string
}
