resource "null_resource" "oc_route" {
  count = var.expose == "route" ? 1 : 0
  triggers = {
    route_namespace = var.namespace
    route_name      = var.name
    route_suffix    = var.route_suffix
    service_name    = var.nginx_ingress_service_name
    service_port    = var.nginx_ingress_port
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
           "host": "${self.triggers.route_name}-${self.triggers.route_suffix}",
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
