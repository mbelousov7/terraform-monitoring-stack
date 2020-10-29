resource "random_integer" "config" {
  min     = 1
  max     = 50000
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    listener_arn = var.name
  }
}

locals {
  labels = merge (
    #{ redeploy = random_integer.config.result },
    { name = var.name },
    { module = "nginx-ingress"},
    var.labels
  )




  #secret_maps_list =  merge (
  #  var.ssl_maps_list
  #)
  #secret_volumes = {}
  #templatefile("${path.module}/backends.tmpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })


}
