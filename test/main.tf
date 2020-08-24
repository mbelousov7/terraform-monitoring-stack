terraform {

  required_version = ">= 0.13"
  backend "kubernetes" {
    secret_suffix    = "state"
    load_config_file = true
    insecure               = true
  }
}
