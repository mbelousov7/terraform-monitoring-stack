resource "null_resource" "oc_route" {
count = var.expose == "route" ? 1 : 0
  triggers = {
    route_namespace = var.namespace
    route_name = var.name
    service_name = var.nginx_ingress_service_name
    service_port = var.nginx_ingress_port
  }

  provisioner "local-exec"  {
    command = <<EOT
    curl --max-time 30 -k  -X POST "$TF_VAR_kubernetes_host"/apis/route.openshift.io/v1/namespaces/${self.triggers.route_namespace}/routes/ \
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
         "tls": {
           "termination": "passthrough"
         },
         "to": {
           "kind": "Service",
           "name": "${self.triggers.nginx_ingress_service_name}",
           "weight": 100
         },
         "wildcardPolicy": "None"
       },
       "status": {
         "ingress": null
       }
    }'
EOT
}

 provisioner "local-exec" {

 when = destroy

 command = <<EOT
    curl --max-time 30 -k -H "Authorization: Bearer $TF_VAR_kubernetes_token"  -X DELETE "$TF_VAR_kubernetes_host"/apis/route.openshift.io/v1/namespaces/${self.triggers.route_namespace}/routes/${self.triggers.route_name}
EOT
 }

}
