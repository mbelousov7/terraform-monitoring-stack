terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  route_prefix = var.route_prefix != null && var.route_prefix != "" ? var.route_prefix : var.route_name
}

resource "null_resource" "oc_route" {
  triggers = {
    route_namespace = var.route_namespace
    route_name      = var.route_name
    service_name    = var.route_service_name
    service_port    = var.route_service_port
    route_prefix    = local.route_prefix
    route_suffix    = var.route_suffix
  }

  provisioner "local-exec" {
    command = <<EOT
    status_code=$(curl -k -o /dev/null -w "%%{http_code}" --max-time 30 -X POST "$TF_VAR_kubernetes_host"/apis/route.openshift.io/v1/namespaces/${self.triggers.route_namespace}/routes/ \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TF_VAR_kubernetes_token" \
    -d '{
        "apiVersion": "route.openshift.io/v1",
        "kind": "Route",
        "metadata": {
         "labels": {
           "name": "${self.triggers.route_name}"
           },
           "name": "${self.triggers.route_name}",
           "namespace": "${self.triggers.route_namespace}"
         },
         "spec": {
           "port": {
             "targetPort": "${self.triggers.service_port}"
           },
           "host": "${self.triggers.route_prefix}-${self.triggers.route_suffix}",
           "tls": {
             "termination": "passthrough"
           },
           "to": {
             "kind": "Service",
             "name": "${self.triggers.service_name}",
             "weight": 100
           },
           "wildcardPolicy": "None"
       },
       "status": {
         "ingress": null
       }
    }')

echo $status_code

if  [ $status_code -eq 400 ]; then
   echo "Route was not created." && exit 1
else
   echo "Route ${self.triggers.route_name} created." && exit 0
fi
EOT
  }

  provisioner "local-exec" {

    when = destroy

    command = <<EOT
    curl --max-time 30 -k -H "Authorization: Bearer $TF_VAR_kubernetes_token"  -X DELETE "$TF_VAR_kubernetes_host"/apis/route.openshift.io/v1/namespaces/${self.triggers.route_namespace}/routes/${self.triggers.route_name}
EOT
  }

}
