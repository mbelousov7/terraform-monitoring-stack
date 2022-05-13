variable "rules_config" {
  description  = "map with rules configuration"
  type         = map(object({
    route         = optional(map(string))
    rules         = map(object({
      filter      = string
      labels      = map(string)
      annotations = map(string)
    }))
  }))
}

variable "path_configs" {
  description = "Path where alert rules are stored."
  type        = string
}

variable "path_rules_output" {
  description = "Path where to write templated rule files."
  type        = string
  default     = "output"
}
