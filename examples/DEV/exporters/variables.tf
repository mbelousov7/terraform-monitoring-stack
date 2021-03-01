# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------
variable "env" {
  description = "enviroment DEV|PSI|PROD"
  type        = string
}

variable "kubernetes_host" {
  description = "kubernetes host:port address  "
  type        = string
}

variable "kubernetes_token" {
  description = "kubernetes token"
  type        = string
}

variable "namespace" {
  description = "kubernetes namespace"
  type        = string
}

variable "path_secrets" {
  description = "path to decrypted sicrets folder "
  type        = string
  default     = "./secrets-decrypt"
}

variable "path_configs" {
  description = "path to configs files"
  type        = string
  default     = "../../global/configs-exporters"
}

variable "exporter_jmx_container_image" {
  description = "jmx exporter image path"
  type        = string
}

variable "replicas_deployment" {
  description = "replicas count for stateless deployments"
  type        = number
  default     = 2
}


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------------------------------------------
