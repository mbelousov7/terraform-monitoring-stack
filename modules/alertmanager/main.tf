locals {
  labels = merge(
    { name = var.name },
    { module = "alertmanager" },
    var.labels
  )

  config_maps_list = concat(var.config_maps_list)
  secret_maps_list = concat(var.secret_maps_list)

  #arg_list = [ for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}-headless.${var.namespace}.${var.dns_path_for_config}:${var.cluster_port}",i)]
  arg_list = [for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}-headless.${var.namespace}.svc.cluster.local:${var.cluster_port}", i)]

  #arg_list = [ for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}-headless:${var.cluster_port}",i)]
  #arg_list = [ for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}:${var.cluster_port}",i)]
  #arg_list = [ for i in range(var.replicas) : format("--cluster.peer=${var.name}-%s.${var.name}:${var.cluster_port}",i)]

}
