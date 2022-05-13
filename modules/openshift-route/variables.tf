variable "route_namespace" {
  description = "Namespace to create route in."
  type        = string
  validation {
    condition     = can(regex("^[[:alnum:]][a-z0-9-]{0,62}[[:alnum:]]$", var.route_namespace))
    error_message = "Must be alphanum max 63 sympols."
  }
}

variable "route_name" {
  description = "Route name to create route, will be used in hostname."
  type        = string
  validation {
    condition     = can(regex("^[[:alnum:]][a-z0-9-]{0,62}[[:alnum:]]$", var.route_name))
    error_message = "Must be alphanum max 63 sympols."
  }
}

variable "route_suffix" {
  description = "Route suffix for route, will be used in hostname."
  type        = string
  validation {
    condition     = can(regex("^[[:alnum:]][a-z0-9-.]{0,63}[[:alnum:]]$", var.route_suffix))
    error_message = "Must conform to DNS 952."
  }
}

variable "route_service_name" {
  description = "Service name to forward route."
  type        = string
  validation {
    condition     = can(regex("^[[:alnum:]][a-z0-9-]{0,62}[[:alnum:]]$", var.route_service_name))
    error_message = "Must be alphanum max 63 sympols."
  }
}

variable "route_prefix" {
  description = "Route prefix for route, will be used in hostname. Route name will be sued if unset"
  type        = string
  default     = null
  validation {
    condition     = (var.route_prefix == null ? true : can(regex("[a-z0-9-]{0,63}[[:alnum:]]$", var.route_prefix)))
    error_message = "Must conform to DNS 952."
  }
}

variable "route_service_port" {
  description = "Service port to forward route."
  type        = string
  validation {
    condition     = can(parseint(var.route_service_port, 10) < 65535)
    error_message = "Must be in 0-65535."
  }
}
