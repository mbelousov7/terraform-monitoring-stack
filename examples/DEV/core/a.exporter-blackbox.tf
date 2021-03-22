module "exporter-blackbox" {
  source          = "../../../modules/exporter-blackbox"
  namespace       = var.namespace
  container_image = var.exporter_blackbox_container_image
  name            = "exporter-blackbox"
  replicas        = var.replicas_deployment
}
