<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_ingress.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_secret.config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.service-headless](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.alertmanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_peer_add_list"></a> [cluster\_peer\_add\_list](#input\_cluster\_peer\_add\_list) | additional alertmanagers peer list(from other kuber cluster or namespace) | `list(any)` | `[]` | no |
| <a name="input_cluster_port"></a> [cluster\_port](#input\_cluster\_port) | n/a | `number` | `9094` | no |
| <a name="input_configPath"></a> [configPath](#input\_configPath) | path to configs folder | `string` | `"/etc/alertmanager"` | no |
| <a name="input_config_data"></a> [config\_data](#input\_config\_data) | alertmanager.yml config map | `map` | <pre>{<br>  "alertmanager.yml": "\n"<br>}</pre> | no |
| <a name="input_config_maps_list"></a> [config\_maps\_list](#input\_config\_maps\_list) | list config maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_container_extra_args"></a> [container\_extra\_args](#input\_container\_extra\_args) | extra command line arguments to pass to conatiner | `list(string)` | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | path to prometheus image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `9093` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.05",<br>  "limits_ephemeral_storage": "1Gi",<br>  "limits_memory": "50M",<br>  "requests_cpu": "0.05",<br>  "requests_ephemeral_storage": "1Gi",<br>  "requests_memory": "50M",<br>  "size_limit": "1Gi"<br>}</pre> | no |
| <a name="input_dataPath"></a> [dataPath](#input\_dataPath) | path to data folder | `string` | `"/data"` | no |
| <a name="input_dataVolume"></a> [dataVolume](#input\_dataVolume) | n/a | `map` | <pre>{<br>  "empty_dir": {},<br>  "name": "storage-volume"<br>}</pre> | no |
| <a name="input_dns_path_for_config"></a> [dns\_path\_for\_config](#input\_dns\_path\_for\_config) | variable resolver for upstream in server.conf depends on instance of kubernetes cluster | `string` | `"svc.cluster.local"` | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 120,<br>  "period_seconds": 60,<br>  "timeout_seconds": 30<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"alertmanager"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for prometheus | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | n/a | yes |
| <a name="input_pod_management_policy"></a> [pod\_management\_policy](#input\_pod\_management\_policy) | n/a | `string` | `"OrderedReady"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 120,<br>  "period_seconds": 60,<br>  "timeout_seconds": 30<br>}</pre> | no |
| <a name="input_reloader_container_image"></a> [reloader\_container\_image](#input\_reloader\_container\_image) | path to configmap-reloader image | `string` | n/a | yes |
| <a name="input_reloader_sidecar_config"></a> [reloader\_sidecar\_config](#input\_reloader\_sidecar\_config) | n/a | `map` | <pre>{<br>  "container_port": 9533,<br>  "container_resources": {<br>    "limits_cpu": "20m",<br>    "limits_memory": "30M",<br>    "requests_cpu": "20m",<br>    "requests_memory": "30M"<br>  },<br>  "name": "reloader"<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `3` | no |
| <a name="input_retentionTime"></a> [retentionTime](#input\_retentionTime) | n/a | `string` | `"170h"` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_secret_maps_list"></a> [secret\_maps\_list](#input\_secret\_maps\_list) | list secret maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | replicas number |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
| <a name="output_service_name_headless"></a> [service\_name\_headless](#output\_service\_name\_headless) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
<!-- END_TF_DOCS -->