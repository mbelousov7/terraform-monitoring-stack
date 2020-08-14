resource "random_integer" "config" {
  min     = 1
  max     = 50000
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    listener_arn = "${var.app_name}"
  }
}

locals {
  labels = merge (
    { redeploy = random_integer.config.result },
    { app = var.app_name },
    var.labels
  )

  secret_volumes = {}




#templatefile("${path.module}/backends.tmpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })


}
