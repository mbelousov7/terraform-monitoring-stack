variable "namespace" {
  description = "kubernetes namespace for jmx-exporter"
  type        = string
  default     = "monitoring"
}

variable "app_name" {
  description = "app(deployment) name"
  type        = string
  default     = "exporter-jmx"
}

variable "labels" {
  description = "kubernetes labels"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = string
  default     = 1
}

variable "strategy" {
  type        = string
  default     = "Recreate"
}

variable "container_image" {
  description = "path to jmx-exporter image"
  type        = string
}

variable "container_name" {
  description = "exporter-jmx pod name"
  type        = string
}

variable "container_port" {
  type        = string
  default     = "5555"
}

variable "container_resources_requests_cpu" {
  type        = string
  default     = "0.02"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "0.1Gi"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "0.03"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "0.2Gi"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

#exporter config variables

variable "system" {
  type        = string
}

variable "env_jmx_role" {
  type        = string
  default     = "default"
}
variable "env_exporter_port" {
  type        = string
  default     = "5555"
}
variable "env_host" {
  type        = string
  default     = "localhost"
}
variable "env_port" {
  type        = string
  default     = "5555"
}
variable "env_jvm_opts" {
  type        = string
  default     = ""
}
variable "env_jmxurl" {
  type        = string
  default     = ""
}
variable "env_ssl" {
  type        = string
  default     = ""
}
variable "env_username" {
  type        = string
  default     = ""
}
variable "env_password" {
  type        = string
  default     = ""
}
