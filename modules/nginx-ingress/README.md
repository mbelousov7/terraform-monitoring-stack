<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.kerberos_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.nginx-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.kerberos_keytab](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.nginx-password-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.nginx-ssl-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_certificate"></a> [ca\_certificate](#input\_ca\_certificate) | Root Ca Cert for mTLS | `string` | `""` | no |
| <a name="input_configMap_volumes"></a> [configMap\_volumes](#input\_configMap\_volumes) | list config maps and volumes | <pre>list(object({<br>    mount_path      = string<br>    name            = string<br>    config_map_name = string<br>    config_map_data = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "config_map_data": {},<br>    "config_map_name": "prometheus-config-main",<br>    "mount_path": "/etc/prometheus",<br>    "name": "config-main-volume"<br>  }<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | n/a | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `8080` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_memory": "150M",<br>  "requests_cpu": "0.2",<br>  "requests_memory": "150M"<br>}</pre> | no |
| <a name="input_dns_path_for_config"></a> [dns\_path\_for\_config](#input\_dns\_path\_for\_config) | variable resolver for upstream in server.conf depends on instance of kubernetes cluster | `string` | `"svc.cluster.local"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_kerberos_config"></a> [kerberos\_config](#input\_kerberos\_config) | kerberos config | `map` | `{}` | no |
| <a name="input_kerberos_keytab"></a> [kerberos\_keytab](#input\_kerberos\_keytab) | kerberos keytab | `list` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | labels | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"nginx-ingress"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | namespace | `string` | n/a | yes |
| <a name="input_nginx_users_map"></a> [nginx\_users\_map](#input\_nginx\_users\_map) | map user\_name = http\_encrypted\_user\_password | `map` | <pre>{<br>  "admin": "$apr1$GqeZ89R1$.qHQjuvzJIdWaFS413SgA/",<br>  "user": "$apr1$A3L4.ORj$xGd9QkfCjDHS8tZWQldOP0"<br>}</pre> | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | n/a | `number` | `1` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | variable for nginx ingress postfix | `string` | `"apps.cluster.local"` | no |
| <a name="input_secret_maps_list"></a> [secret\_maps\_list](#input\_secret\_maps\_list) | list secret maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_server_map"></a> [server\_map](#input\_server\_map) | server config list | <pre>map(object({<br>    name           = optional(string)<br>    app_port       = optional(number)<br>    auth_locations = optional(map(list(string)))<br>    proxy_pass     = optional(map(string))<br>    ssl_data       = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_strategy"></a> [strategy](#input\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | app service name |
<!-- END_TF_DOCS -->