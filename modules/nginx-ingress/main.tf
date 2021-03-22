/*
resource "random_integer" "config" {
  min     = 1
  max     = 50000
  keepers = {
    listener_arn = var.name
  }
}
*/
locals {
  labels = merge(
    #{ redeploy = random_integer.config.result },
    { name = var.name },
    { module = "nginx-ingress" },
    var.labels
  )

  annotations = {
    config_maps_sha1 = sha1(jsonencode(merge(
      kubernetes_secret.nginx-config-secret.data,
      kubernetes_secret.nginx-password-secret.data,
      var.server_map,
    )))
  }

  #secret_maps_list =  merge (
  #  var.ssl_maps_list
  #)
  #secret_volumes = {}
  #templatefile("${path.module}/backends.tmpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })


}
