# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------

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

variable "nginx_ingress_port" {
  description = "nginx_ingress_port"
  type        = string
  default     = 8080
}


/*
variable "prometheus_list" {
  description = "prometheus config list"
  type = list(object({
    app_name = string
  }))
  default = [
    {
      app_name = "prometheus"
    }
  ]
}
*/
