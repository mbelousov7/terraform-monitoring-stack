variable "namespace" {
  description = "kubernetes namespace for exporter-sql-select"
  type        = string
}

variable "name" {
  description = "app(deployment) name"
  type        = string
  default     = "exporter-sql-select"
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
  description = "path to exporter-sql-select"
  type        = string
}

variable "container_port" {
  type        = string
  default     = "5000"
}


variable "container_resources_requests_cpu" {
  type        = string
  default     = "50m"
}

variable "container_resources_limits_cpu" {
  type        = string
  default     = "90m"
}

variable "container_resources_requests_memory" {
  type        = string
  default     = "150Mi"
}

variable "container_resources_limits_memory" {
  type        = string
  default     = "250Mi"
}

variable "service_type" {
  type        = string
  default     = "ClusterIP"
}

variable "system" {
  type        = string
  default     = "system"
}

variable "env" {
  description = "main pod enviroment variables, values provided from outside the module"
  type        = map
  default     = {
     PATH_TO_CONFIG_FILE = "/exporter-sql/config/config.yml"
	 PATH_TO_RULES_FILE = "/exporter-sql/rules/rules.yml"
  }
}

variable "config_data" {
}

variable "rules_data" {
}

